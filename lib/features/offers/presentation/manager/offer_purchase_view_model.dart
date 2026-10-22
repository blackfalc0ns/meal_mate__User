import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/payment/payment_attempt.dart';
import 'package:meal_meat_user/core/payment/payment_attempt_store.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_customer_offer_details_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_offer_purchase_options_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offer_purchase_state.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';

@injectable
class OfferPurchaseViewModel extends Cubit<OfferPurchaseState> {
  OfferPurchaseViewModel(
    this._getDetails,
    this._getOptions,
    this._getSummary,
    this._getMethods,
    this._checkout,
    this._prefs,
    this._attemptStore,
    this._tokenService,
  ) : super(const OfferPurchaseState());

  final GetCustomerOfferDetailsUseCase _getDetails;
  final GetOfferPurchaseOptionsUseCase _getOptions;
  final GetSubscriptionSummaryUseCase _getSummary;
  final GetPaymentMethodsUseCase _getMethods;
  final CheckoutSubscriptionUseCase _checkout;
  final SharedPrefHelper _prefs;
  final PaymentAttemptStore _attemptStore;
  final TokenService _tokenService;
  int _loadGeneration = 0;
  int _summaryGeneration = 0;

  Future<void> open(String offerId) async {
    emit(state.copyWith(isOptionsLoading: true, clearFailure: true));
    final details = await _getDetails(offerId);
    if (isClosed) return;
    switch (details) {
      case ApiSuccessResult():
        emit(state.copyWith(offerDetails: details.data));
        await load(offerId);
      case ApiErrorResult():
        emit(state.copyWith(isOptionsLoading: false, failure: details.failure));
    }
  }

  Future<void> load(
    String offerId, {
    String? startDate,
    bool? includeFriday,
  }) async {
    final generation = ++_loadGeneration;
    ++_summaryGeneration;
    emit(
      state.copyWith(
        isOptionsLoading: true,
        clearFailure: true,
        clearSummary: true,
        clearQuoteExpiry: true,
        clearCheckout: true,
      ),
    );
    final result = await _getOptions(
      offerId,
      startDate: startDate,
      includeFriday: includeFriday,
    );
    if (isClosed || generation != _loadGeneration) return;
    switch (result) {
      case ApiSuccessResult():
        final previous = state.selectedOption;
        final dates =
            result.data.options
                .map((option) => DateTime.tryParse(option.startDate))
                .whereType<DateTime>()
                .toList()
              ..sort();
        final selected = result.data.options
            .where(
              (option) =>
                  previous != null &&
                  option.programId == previous.programId &&
                  option.bundleId == previous.bundleId &&
                  option.tier == previous.tier &&
                  option.durationDays == previous.durationDays,
            )
            .firstOrNull;
        emit(
          state.copyWith(
            isOptionsLoading: false,
            options: result.data,
            earliestStartDate:
                state.earliestStartDate ?? (dates.isEmpty ? null : dates.first),
            selectedOption: selected,
            clearSelectedOption: selected == null,
            clearSummary: selected == null,
            clearQuoteExpiry: selected == null,
          ),
        );
        if (selected != null) await selectOption(selected);
      case ApiErrorResult():
        emit(state.copyWith(isOptionsLoading: false, failure: result.failure));
    }
  }

  Future<void> selectOption(OfferPurchaseOptionEntity option) async {
    if (state.options?.isFamily == true) return;
    final generation = ++_summaryGeneration;
    emit(
      state.copyWith(
        selectedOption: option,
        isSummaryLoading: true,
        termsAccepted: false,
        clearSummary: true,
        clearQuoteExpiry: true,
        clearCheckout: true,
        clearFailure: true,
      ),
    );
    final result = await _getSummary(
      SubscriptionSummaryRequestEntity(
        includeFriday: option.includeFriday,
        durationDays: option.durationDays,
        tier: option.tier,
        bundleId: option.bundleId,
        programId: option.programId,
        startDate: option.startDate,
        offerId: state.options?.offerId,
        promoCode: state.promoCode,
      ),
    );
    if (isClosed || generation != _summaryGeneration) return;
    switch (result) {
      case ApiSuccessResult():
        final summary = result.data;
        final expiry = DateTime.tryParse(summary.summaryExpiresAtUtc ?? '');
        final serverNow = DateTime.tryParse(summary.serverNowUtc ?? '');
        final localExpiry = expiry == null || serverNow == null
            ? null
            : DateTime.now().add(expiry.difference(serverNow));
        emit(
          state.copyWith(
            isSummaryLoading: false,
            summary: summary,
            quoteExpiresAtLocal: localExpiry,
            clearQuoteExpiry: localExpiry == null,
            clearSelectedMethod: true,
          ),
        );
        if (summary.canCheckout &&
            summary.quoteId?.isNotEmpty == true &&
            summary.finalPrice > 0) {
          await _loadMethods(summary.finalPrice, generation);
        }
      case ApiErrorResult():
        emit(state.copyWith(isSummaryLoading: false, failure: result.failure));
    }
  }

  Future<void> changePromoCode(String? code) async {
    final normalized = code?.trim().toUpperCase();
    emit(
      state.copyWith(
        promoCode: normalized,
        clearPromoCode: normalized == null || normalized.isEmpty,
      ),
    );
    final selected = state.selectedOption;
    if (selected != null) await selectOption(selected);
  }

  Future<void> changeDate(String date, bool includeFriday) async {
    final offerId = state.options?.offerId;
    if (offerId == null) return;
    await load(offerId, startDate: date, includeFriday: includeFriday);
  }

  void selectMethod(PaymentMethodEntity method) {
    if (method.isAvailable && method.id != null) {
      emit(state.copyWith(selectedMethod: method));
    }
  }

  void acceptTerms(bool accepted) =>
      emit(state.copyWith(termsAccepted: accepted));

  void clearCheckout() => emit(state.copyWith(clearCheckout: true));

  Future<void> _loadMethods(double amount, int generation) async {
    emit(state.copyWith(isMethodsLoading: true));
    final result = await _getMethods(amount: amount);
    if (isClosed || generation != _summaryGeneration) return;
    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isMethodsLoading: false, methods: result.data));
      case ApiErrorResult():
        emit(state.copyWith(isMethodsLoading: false, failure: result.failure));
    }
  }

  Future<void> pay({
    required String callbackUrl,
    required String errorUrl,
  }) async {
    if (!state.canPay) return;
    final option = state.selectedOption!;
    final summary = state.summary!;
    final offerId = state.options!.offerId;
    final methodId = state.selectedMethod!.id!;
    final promoCode = state.promoCode;
    emit(state.copyWith(isCheckoutLoading: true, clearFailure: true));
    final customerId = await _tokenService.getCurrentUserId() ?? '';
    if (isClosed) return;
    final fingerprint = [
      offerId,
      summary.quoteId!,
      option.selectionKey,
      promoCode ?? '',
      methodId,
      callbackUrl,
      errorUrl,
    ].join('|');
    final prefKey = 'offer_checkout_attempt_${customerId}_$offerId';
    String? key;
    final previous = _prefs.getData(key: prefKey);
    if (previous is String) {
      try {
        final record = jsonDecode(previous) as Map<String, dynamic>;
        if (record['fingerprint'] == fingerprint) {
          key = record['key'] as String?;
        }
      } catch (_) {}
    }
    key ??= _newIdempotencyKey();
    final saved = await _prefs.saveData(
      key: prefKey,
      val: jsonEncode({'fingerprint': fingerprint, 'key': key}),
    );
    if (isClosed) return;
    if (!saved) {
      emit(
        state.copyWith(
          isCheckoutLoading: false,
          failure: Failure(
            errorMessage: 'Could not save payment attempt. Please retry.',
            code: 'checkout.idempotency_storage_failed',
          ),
        ),
      );
      return;
    }

    final result = await _checkout(
      PaymentCheckoutRequestEntity(
        programId: option.programId,
        bundleId: option.bundleId,
        tier: option.tier,
        durationDays: option.durationDays,
        startDate: option.startDate,
        includeFriday: option.includeFriday,
        offerId: offerId,
        quoteId: summary.quoteId,
        promoCode: promoCode,
        idempotencyKey: key,
        paymentMethodId: methodId,
        callbackUrl: callbackUrl,
        errorUrl: errorUrl,
        correlationId: key,
      ),
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        final checkout = result.data;
        if (customerId.isNotEmpty &&
            checkout.subscriptionId.isNotEmpty &&
            checkout.paymentId?.isNotEmpty == true) {
          try {
            await _attemptStore.save(
              PaymentAttempt(
                ownerCustomerId: customerId,
                subscriptionId: checkout.subscriptionId,
                paymentId: checkout.paymentId!,
                createdAtUtc: DateTime.now().toUtc(),
                idempotencyKey: key,
                state: 'redirected',
              ),
            );
          } catch (_) {
            if (!isClosed) {
              emit(
                state.copyWith(
                  isCheckoutLoading: false,
                  failure: Failure(
                    errorMessage:
                        'Could not save payment recovery. Please verify your subscription status.',
                    code: 'checkout.attempt_persistence_failed',
                  ),
                ),
              );
            }
            return;
          }
        }
        if (isClosed) return;
        emit(state.copyWith(isCheckoutLoading: false, checkout: checkout));
      case ApiErrorResult():
        final payload = result.failure.exception.response;
        final pendingId = payload is Map ? payload['subscriptionId'] : null;
        if (pendingId is String && pendingId.isNotEmpty) {
          emit(
            state.copyWith(
              isCheckoutLoading: false,
              checkout: PaymentCheckoutEntity.recovery(
                subscriptionId: pendingId,
                paymentId: '',
              ),
            ),
          );
          return;
        }
        emit(state.copyWith(isCheckoutLoading: false, failure: result.failure));
    }
  }

  String _newIdempotencyKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
