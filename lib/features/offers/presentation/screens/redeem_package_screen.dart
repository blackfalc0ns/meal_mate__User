import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_countdown_timer_widget.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offer_purchase_state.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offer_purchase_view_model.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_method_tile.dart';

class RedeemPackageScreen extends StatefulWidget {
  const RedeemPackageScreen({super.key, required this.offer});
  final OfferEntity offer;

  @override
  State<RedeemPackageScreen> createState() => _RedeemPackageScreenState();
}

class _RedeemPackageScreenState extends State<RedeemPackageScreen> {
  late final OfferPurchaseViewModel _viewModel;
  final _promoController = TextEditingController();
  Timer? _quoteExpiryTimer;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<OfferPurchaseViewModel>();
    unawaited(_viewModel.open(widget.offer.id));
  }

  @override
  void dispose() {
    _quoteExpiryTimer?.cancel();
    _promoController.dispose();
    unawaited(_viewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _viewModel,
    child: BlocConsumer<OfferPurchaseViewModel, OfferPurchaseState>(
      listener: (context, state) {
        _quoteExpiryTimer?.cancel();
        final expiry = state.quoteExpiresAtLocal;
        if (expiry != null && expiry.isAfter(DateTime.now())) {
          _quoteExpiryTimer = Timer(expiry.difference(DateTime.now()), () {
            if (mounted) setState(() {});
          });
        }
        final checkout = state.checkout;
        if (checkout != null) {
          unawaited(
            Navigator.of(context).pushNamed(
              AppRoutes.paymentWebView,
              arguments: PaymentWebViewArgs(checkout: checkout),
            ),
          );
          _viewModel.clearCheckout();
        }
      },
      builder: (context, state) {
        final locale = context.localization;
        final color = context.colorScheme;
        final lang = Localizations.localeOf(context).languageCode;
        final options = state.options;
        final summary = state.summary;
        final offer = state.offerDetails ?? widget.offer;
        return Scaffold(
          appBar: CustomAppBar(
            title: locale.offer_redeem_title,
            showBackButton: true,
          ),
          body: state.isOptionsLoading && options == null
              ? const Center(child: CustomProgressIndicator())
              : SafeArea(
                  child: DefaultTextStyle.merge(
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(Spacing.lg),
                      children: [
                        Text(
                          offer.title(lang),
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size18,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        if (offer.bannerImageUrl?.isNotEmpty == true) ...[
                          Image.network(
                            offer.bannerImageUrl!,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox.shrink(),
                          ),
                          const SizedBox(height: Spacing.sm),
                        ],
                        if (offer.description(lang).isNotEmpty)
                          Text(offer.description(lang)),
                        if (offer.endsAt != null)
                          OfferCountdownTimerWidget(
                            endsAt: offer.endsAt!,
                            serverNowUtc: offer.serverNowUtc,
                          ),
                        if (offer.terms(lang)?.isNotEmpty == true) ...[
                          const SizedBox(height: Spacing.sm),
                          Text(
                            locale.offer_details_info_terms_label,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size14,
                              color: color.onSurface,
                            ),
                          ),
                          Text(offer.terms(lang)!),
                        ],
                        if (state.failure != null) ...[
                          Text(
                            ErrorMessagePresenter.fromFailure(
                              context,
                              state.failure!,
                            ),
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.error,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _viewModel.open(widget.offer.id),
                            child: Text(locale.payment_failed_retry_button),
                          ),
                        ],
                        if (options?.isFamily == true)
                          AppButton(
                            text: locale.family_packages_header_title,
                            onPressed: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.familyPackageSelection),
                          ),
                        if (options != null && !options.isFamily) ...[
                          if (state.isOptionsLoading)
                            const Center(
                              child: CustomProgressIndicator(size: 52),
                            ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_month_outlined),
                            label: Text(
                              locale.subscription_start_date_picker_label,
                            ),
                            onPressed: () async {
                              final firstDate =
                                  state.earliestStartDate ?? DateTime.now();
                              final initial =
                                  DateTime.tryParse(
                                    state.selectedOption?.startDate ??
                                        options
                                            .options
                                            .firstOrNull
                                            ?.startDate ??
                                        '',
                                  ) ??
                                  firstDate;
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: initial.isBefore(firstDate)
                                    ? firstDate
                                    : initial,
                                firstDate: firstDate,
                                lastDate: firstDate.add(
                                  const Duration(days: 3650),
                                ),
                              );
                              if (picked != null) {
                                final date =
                                    '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                unawaited(
                                  _viewModel.changeDate(
                                    date,
                                    state.selectedOption?.includeFriday ??
                                        false,
                                  ),
                                );
                              }
                            },
                          ),
                          if (state.selectedOption != null)
                            SwitchListTile(
                              title: Text(locale.subscription_add_friday),
                              subtitle: Text(
                                state.selectedOption!.includeFriday
                                    ? locale.subscription_with_friday
                                    : locale.subscription_without_friday,
                              ),
                              value: state.selectedOption!.includeFriday,
                              onChanged: (value) => unawaited(
                                _viewModel.changeDate(
                                  state.selectedOption!.startDate,
                                  value,
                                ),
                              ),
                            ),
                          for (final reason in options.blockingReasons)
                            Text(
                              _reason(context, reason, lang),
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size13,
                                color: color.error,
                              ),
                            ),
                          if (options.options.isEmpty)
                            Text(locale.subscription_flow_empty_options),
                          for (final option in options.options)
                            Card(
                              child: InkWell(
                                onTap:
                                    option.canCheckout &&
                                        !state.isOptionsLoading
                                    ? () => _viewModel.selectOption(option)
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(Spacing.md),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (option.imageUrl?.isNotEmpty == true)
                                        Image.network(
                                          option.imageUrl!,
                                          height: 96,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, error, stackTrace) => Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                color: color.onSurfaceVariant,
                                              ),
                                        ),
                                      if (option.imageUrl?.isNotEmpty != true)
                                        Icon(
                                          Icons.image_not_supported_outlined,
                                          color: color.onSurfaceVariant,
                                        ),
                                      Text(
                                        lang == 'ar'
                                            ? (option.programNameAr ??
                                                  option.programNameEn ??
                                                  '')
                                            : (option.programNameEn ??
                                                  option.programNameAr ??
                                                  ''),
                                      ),
                                      Text(
                                        lang == 'ar'
                                            ? (option.bundleNameAr ??
                                                  option.bundleNameEn ??
                                                  '')
                                            : (option.bundleNameEn ??
                                                  option.bundleNameAr ??
                                                  ''),
                                      ),
                                      Text(
                                        '${lang == 'ar' ? (option.tierNameAr ?? option.tier) : (option.tierNameEn ?? option.tier)} · ${option.durationDays} ${locale.billing_uncompleted_days}',
                                      ),
                                      Text(
                                        '${option.startDate} – ${option.endDate ?? ''}',
                                      ),
                                      if (option.finalPrice != null)
                                        Text(
                                          '${option.finalPrice!.toStringAsFixed(3)} ${option.currencyCode ?? ''}',
                                        ),
                                      for (final reason
                                          in option.blockingReasons)
                                        Text(
                                          _reason(context, reason, lang),
                                          style: getRegularStyle(
                                            fontFamily: FontConstant.alexandria,
                                            fontSize: FontSize.size12,
                                            color: color.error,
                                          ),
                                        ),
                                      if (state.selectedOption?.selectionKey ==
                                          option.selectionKey)
                                        Icon(
                                          Icons.check_circle,
                                          color: color.primary,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (state.isSummaryLoading || state.isMethodsLoading)
                            const Center(
                              child: CustomProgressIndicator(size: 52),
                            ),
                          if (summary != null) ...[
                            const SizedBox(height: Spacing.md),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _promoController,
                                    decoration: InputDecoration(
                                      labelText:
                                          locale.offer_details_code_label,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _viewModel.changePromoCode(
                                    _promoController.text,
                                  ),
                                  child: Text(locale.offer_promo_apply_code),
                                ),
                              ],
                            ),
                            Text(
                              locale.offer_checkout_order_summary_title,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size15,
                                color: color.onSurface,
                              ),
                            ),
                            if (summary.coupon != null &&
                                summary.coupon!.message(lang).isNotEmpty)
                              Text(
                                summary.coupon!.message(lang),
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size13,
                                  color: summary.coupon!.isValid
                                      ? color.primary
                                      : color.error,
                                ),
                              ),
                            if (state.quoteExpiresAtLocal != null &&
                                !state.quoteExpiresAtLocal!.isAfter(
                                  DateTime.now(),
                                ))
                              Text(
                                locale.offer_quote_expired,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size13,
                                  color: color.error,
                                ),
                              ),
                            if (state.quoteExpiresAtLocal != null &&
                                !state.quoteExpiresAtLocal!.isAfter(
                                  DateTime.now(),
                                ))
                              TextButton(
                                onPressed: state.selectedOption == null
                                    ? null
                                    : () => _viewModel.selectOption(
                                        state.selectedOption!,
                                      ),
                                child: Text(locale.payment_failed_retry_button),
                              ),
                            Text(
                              '${locale.subscription_success_start_date_label}: ${summary.startDate}',
                            ),
                            if (summary.paymentDate?.isNotEmpty == true)
                              Text(
                                '${locale.subscription_success_payment_date_label}: ${summary.paymentDate}',
                              ),
                            Text(
                              '${locale.subscription_success_end_date_label}: ${summary.endDate}',
                            ),
                            Text(
                              '${locale.offer_checkout_original_price}: ${summary.basePrice.toStringAsFixed(summary.moneyScale)} ${summary.currencyCode}',
                            ),
                            Text(
                              '${locale.offer_checkout_discount_amount}: ${summary.discount.toStringAsFixed(summary.moneyScale)} ${summary.currencyCode}',
                            ),
                            Text(
                              '${locale.offer_checkout_final_total}: ${summary.finalPrice.toStringAsFixed(summary.moneyScale)} ${summary.currencyCode}',
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size15,
                                color: color.onSurface,
                              ),
                            ),
                            if (summary.blockingReasonDetails.isNotEmpty)
                              for (final reason
                                  in summary.blockingReasonDetails)
                                Text(
                                  (lang == 'ar'
                                          ? reason.messageAr
                                          : reason.messageEn) ??
                                      ErrorMessagePresenter.mapCode(
                                        context,
                                        reason.code,
                                      ),
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size13,
                                    color: color.error,
                                  ),
                                ),
                            if (summary.blockingReasonDetails.isEmpty &&
                                summary.checkoutBlockReason != null)
                              Text(
                                ErrorMessagePresenter.mapCode(
                                  context,
                                  summary.checkoutBlockReason!,
                                ),
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size13,
                                  color: color.error,
                                ),
                              ),
                            for (final method in state.methods)
                              PaymentMethodTile(
                                method: method,
                                isSelected:
                                    state.selectedMethod?.id == method.id,
                                onTap: () => _viewModel.selectMethod(method),
                              ),
                            if (summary.termsAcceptanceRequired)
                              CheckboxListTile(
                                value: state.termsAccepted,
                                onChanged: (value) =>
                                    _viewModel.acceptTerms(value ?? false),
                                title: Text(locale.profile_settings_terms),
                              ),
                            AppButton(
                              text: locale.offer_checkout_proceed_button,
                              onPressed: state.canPay
                                  ? () => _viewModel.pay(
                                      callbackUrl:
                                          'https://maelmate.runasp.net/payment/callback',
                                      errorUrl:
                                          'https://maelmate.runasp.net/payment/error',
                                    )
                                  : null,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
        );
      },
    ),
  );

  String _reason(
    BuildContext context,
    OfferPurchaseBlockingReasonEntity reason,
    String lang,
  ) {
    final message = lang == 'ar'
        ? (reason.messageAr ?? reason.messageEn)
        : (reason.messageEn ?? reason.messageAr);
    return message ?? ErrorMessagePresenter.mapCode(context, reason.code);
  }
}
