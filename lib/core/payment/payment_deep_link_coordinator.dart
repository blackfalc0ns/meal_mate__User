import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/payment/payment_attempt_store.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_screen_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

class PaymentDeepLinkCoordinator with WidgetsBindingObserver {
  PaymentDeepLinkCoordinator({
    required this._tokenService,
    required this._paymentAttemptStore,
    required this._navigatorService,
  });

  final TokenService _tokenService;
  final PaymentAttemptStore _paymentAttemptStore;
  final AppNavigatorService _navigatorService;

  PaymentReturn? _pendingReturn;
  String? _lastHandledPaymentId;
  DateTime? _lastHandledAt;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    _checkInitialRoute();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void _checkInitialRoute() {
    final initialRoute =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    if (initialRoute.isNotEmpty && initialRoute.contains('mealmate://')) {
      final uri = Uri.tryParse(initialRoute);
      if (uri != null) {
        final paymentReturn = parsePaymentReturn(uri);
        if (paymentReturn != null) {
          unawaited(handleReturn(paymentReturn));
        }
      }
    }
  }

  @override
  Future<bool> didPushRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    if (uri.scheme == 'mealmate') {
      final paymentReturn = parsePaymentReturn(uri);
      if (paymentReturn != null) {
        await handleReturn(paymentReturn);
        return true;
      }
    }
    return super.didPushRouteInformation(routeInformation);
  }

  Future<void> handleReturn(PaymentReturn paymentReturn) async {
    final now = DateTime.now();
    final handleKey = paymentReturn.isCampaign
        ? (paymentReturn.sessionId?.isNotEmpty == true
              ? paymentReturn.sessionId!
              : paymentReturn.paymentId)
        : paymentReturn.paymentId;
    if (_lastHandledPaymentId == handleKey &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!).inSeconds < 3) {
      return;
    }
    _lastHandledPaymentId = handleKey;
    _lastHandledAt = now;

    final isAuthenticated = await _tokenService.hasValidSessionTokens();
    if (!isAuthenticated) {
      _pendingReturn = paymentReturn;
      return;
    }

    await _processAuthenticatedReturn(paymentReturn);
  }

  Future<void> onUserAuthenticated() async {
    if (_pendingReturn != null) {
      final queued = _pendingReturn!;
      _pendingReturn = null;
      await _processAuthenticatedReturn(queued);
    }
  }

  Future<void> _processAuthenticatedReturn(PaymentReturn paymentReturn) async {
    final customerId = await _tokenService.getCurrentUserId() ?? '';
    if (customerId.isEmpty) return;

    if (paymentReturn.isCampaign) {
      final sessionId = paymentReturn.sessionId ?? '';
      await _navigatorService.pushNamedWhenReady(
        AppRoutes.campaignPayment,
        arguments: CampaignPaymentScreenArgs(
          sessionId: sessionId,
          paymentId: paymentReturn.paymentId,
          callbackStatus: paymentReturn.callbackStatus,
        ),
      );
      return;
    }

    final attempt = await _paymentAttemptStore.readForCustomer(customerId);
    final isFamily = attempt?.isFamily ?? false;
    final subscriptionId =
        (attempt != null &&
            (attempt.paymentId == paymentReturn.paymentId ||
                attempt.paymentId.isEmpty))
        ? attempt.subscriptionId
        : '';

    if (paymentReturn.destination == PaymentReturnDestination.review &&
        attempt != null) {
      await _paymentAttemptStore.save(attempt.copyWith(reviewRequired: true));
    }

    final checkout = PaymentCheckoutEntity.recovery(
      subscriptionId: subscriptionId,
      paymentId: paymentReturn.paymentId,
    );

    await _navigatorService.pushNamedWhenReady(
      AppRoutes.paymentWebView,
      arguments: PaymentWebViewArgs(
        checkout: checkout,
        flowType: isFamily ? 'family' : 'individual',
        batchId: attempt?.batchId,
        batchVersion: attempt?.batchVersion,
      ),
    );
  }
}
