import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offer_purchase_state.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offer_purchase_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_subscription_package_summary_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/redeem_package_bottom_bar.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/redeem_package_includes_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/redeem_package_price_card.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_method_tile.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_delivery_address_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_participating_restaurants_card.dart';

class OfferSubscriptionSummaryScreen extends StatelessWidget {
  const OfferSubscriptionSummaryScreen({
    super.key,
    required this.viewModel,
  });

  final OfferPurchaseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    return BlocProvider.value(
      value: viewModel,
      child: BlocConsumer<OfferPurchaseViewModel, OfferPurchaseState>(
        listener: (context, state) {
          final checkout = state.checkout;
          if (checkout != null) {
            unawaited(
              Navigator.of(context).pushNamed(
                AppRoutes.paymentWebView,
                arguments: PaymentWebViewArgs(checkout: checkout),
              ),
            );
            viewModel.clearCheckout();
          }
        },
        builder: (context, state) {
          final summary = state.summary;
          final selectedOption = state.selectedOption;

          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.offer_checkout_order_summary_title,
              showBackButton: true,
            ),
            bottomNavigationBar: summary != null
                ? RedeemPackageBottomBar(
                    finalPrice: summary.finalPrice,
                    currency: summary.currencyCode.isNotEmpty
                        ? summary.currencyCode
                        : locale.currency,
                    canPay: state.canPay,
                    isLoading: state.isCheckoutLoading,
                    onPay: () => unawaited(
                      viewModel.pay(
                        callbackUrl:
                            'https://maelmate.runasp.net/payment/callback',
                        errorUrl:
                            'https://maelmate.runasp.net/payment/error',
                      ),
                    ),
                  )
                : null,
            body: state.isSummaryLoading || state.isMethodsLoading
                ? const Center(child: CustomProgressIndicator())
                : summary == null || selectedOption == null
                    ? Center(
                        child: Text(
                          locale.payment_failed_card_title,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      )
                    : SafeArea(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(Spacing.md),
                          children: [
                            // 1. Selected Package Summary Card
                            OfferSubscriptionPackageSummaryCard(
                              option: selectedOption,
                              onChangePackage: () => Navigator.of(context).pop(),
                            ),

                            // 2. Delivery Address Card
                            if (summary.address != null) ...[
                              SubscriptionDeliveryAddressCard(
                                address: summary.address,
                              ),
                              const SizedBox(height: Spacing.md),
                            ],

                            // 3. Participating Restaurants Card (distinct from API)
                            SubscriptionParticipatingRestaurantsCard(
                              restaurants: summary.restaurants,
                              totalCount: summary.restaurantCount,
                            ),
                            const SizedBox(height: Spacing.md),

                            // 4. Inclusions Card ("يشمل اشتراكك")
                            RedeemPackageIncludesCard(
                              includes: summary.includes,
                            ),

                            // 5. Financial Price Card (Clean direct discount breakdown)
                            RedeemPackagePriceCard(summary: summary),

                            // Quote Expiration Banner if expired
                            if (state.quoteExpiresAtLocal != null &&
                                !state.quoteExpiresAtLocal!.isAfter(
                                  DateTime.now(),
                                )) ...[
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: Spacing.md,
                                ),
                                padding: const EdgeInsets.all(Spacing.md),
                                decoration: BoxDecoration(
                                  color: color.errorContainer.withValues(
                                    alpha: 0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Spacing.radiusMd,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.timer_off_outlined,
                                      color: color.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: Spacing.sm),
                                    Expanded(
                                      child: Text(
                                        locale.offer_quote_expired,
                                        style: getRegularStyle(
                                          fontFamily: FontConstant.alexandria,
                                          fontSize: FontSize.size12,
                                          color: color.error,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => unawaited(
                                        viewModel.selectOption(selectedOption),
                                      ),
                                      child: Text(
                                        locale.payment_failed_retry_button,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Blocking Reasons on summary if any
                            if (summary.blockingReasonDetails.isNotEmpty)
                              for (final reason
                                  in summary.blockingReasonDetails)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: Spacing.xs,
                                  ),
                                  child: Text(
                                    (lang == 'ar'
                                            ? reason.messageAr
                                            : reason.messageEn) ??
                                        ErrorMessagePresenter.mapCode(
                                          context,
                                          reason.code,
                                        ),
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size12,
                                      color: color.error,
                                    ),
                                  ),
                                ),
                            if (summary.blockingReasonDetails.isEmpty &&
                                summary.checkoutBlockReason != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Spacing.xs,
                                ),
                                child: Text(
                                  ErrorMessagePresenter.mapCode(
                                    context,
                                    summary.checkoutBlockReason!,
                                  ),
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size12,
                                    color: color.error,
                                  ),
                                ),
                              ),

                            // 6. Payment Methods Selection
                            if (state.methods.isNotEmpty) ...[
                              const SizedBox(height: Spacing.xs),
                              Text(
                                locale.payment_method_section_title,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size14,
                                  color: color.onSurface,
                                ),
                              ),
                              const SizedBox(height: Spacing.sm),
                              for (final method in state.methods) ...[
                                PaymentMethodTile(
                                  method: method,
                                  isSelected:
                                      state.selectedMethod?.id == method.id,
                                  onTap: () => viewModel.selectMethod(method),
                                ),
                                const SizedBox(height: Spacing.sm),
                              ],
                            ],

                            // 7. Terms & Conditions Checkbox
                            Theme(
                              data: Theme.of(context).copyWith(
                                checkboxTheme: CheckboxThemeData(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      Spacing.radiusXs,
                                    ),
                                  ),
                                  side: BorderSide(
                                    color: color.outline,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: CheckboxListTile(
                                value: state.termsAccepted,
                                onChanged: (value) =>
                                    viewModel.acceptTerms(value ?? false),
                                title: Text(
                                  locale.profile_settings_terms,
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size12,
                                    color: color.onSurface,
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                activeColor: color.primary,
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
