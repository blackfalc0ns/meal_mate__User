import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/create_campaign_checkout_session_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/activation_success_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/offer_checkout_args.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';

class PromoAppliedCheckoutScreen extends StatefulWidget {
  const PromoAppliedCheckoutScreen({super.key, required this.args});

  final OfferCheckoutArgs args;

  @override
  State<PromoAppliedCheckoutScreen> createState() =>
      _PromoAppliedCheckoutScreenState();
}

class _PromoAppliedCheckoutScreenState
    extends State<PromoAppliedCheckoutScreen> {
  bool _isLoading = false;

  Future<void> _handlePayment() async {
    setState(() => _isLoading = true);

    try {
      // 1. If offer has a campaignId, create checkout session
      if (widget.args.offer.campaignId != null &&
          widget.args.offer.campaignId!.isNotEmpty) {
        final sessionUseCase = getIt<CreateCampaignCheckoutSessionUseCase>();
        await sessionUseCase(
          campaignId: widget.args.offer.campaignId!,
          bundleId:
              widget.args.bundleId ?? 'a1b2c3d4-e5f6-7890-1234-567890abcdef',
          durationDays: widget.args.durationDays,
          deliveryGovernorate: widget.args.deliveryGovernorate,
        );
      }

      // 2. Execute checkout via existing checkout subscription usecase
      final checkoutUseCase = getIt<CheckoutSubscriptionUseCase>();
      final request = PaymentCheckoutRequestEntity(
        programId:
            widget.args.programId ?? 'c4d15678-e123-4567-8901-123456789abc',
        bundleId:
            widget.args.bundleId ?? 'a1b2c3d4-e5f6-7890-1234-567890abcdef',
        tier: widget.args.tier ?? '0',
        durationDays: widget.args.durationDays,
        startDate: DateTime.now()
            .add(const Duration(days: 1))
            .toIso8601String()
            .split('T')
            .first,
        callbackUrl: 'http://maelmate.runasp.net/payment/callback',
        errorUrl: 'http://maelmate.runasp.net/payment/error',
        includeFriday: false,
        paymentMethodId: 1,
        correlationId: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      final result = await checkoutUseCase(request);

      if (!mounted) return;

      switch (result) {
        case ApiSuccessResult(:final data):
          // If paymentUrl is returned, open payment web view
          if (data.paymentUrl.isNotEmpty) {
            final paymentSuccess = await Navigator.of(context).pushNamed(
              AppRoutes.paymentWebView,
              arguments: PaymentWebViewArgs(checkout: data),
            );

            if (!mounted) return;

            if (paymentSuccess == true) {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.activationSuccess,
                arguments: ActivationSuccessArgs(
                  subscriptionId: data.subscriptionId,
                  checkoutArgs: widget.args,
                ),
              );
            }
          } else {
            // Direct activation
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.activationSuccess,
              arguments: ActivationSuccessArgs(
                subscriptionId: data.subscriptionId,
                checkoutArgs: widget.args,
              ),
            );
          }
        case ApiErrorResult(:final failure):
          final message = ErrorMessagePresenter.fromFailure(context, failure);
          CustomSnackbar.showError(context: context, message: message);
      }
    } catch (e) {
      if (!mounted) return;
      final ex = ApiExceptionMapper.fromError(e);
      final message = ErrorMessagePresenter.userFacingMessage(context, ex);
      CustomSnackbar.showError(context: context, message: message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final args = widget.args;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.offer_checkout_title,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.md),

              // ── Applied Banner ──
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(Spacing.md),
                  border: Border.all(
                    color: color.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.primary.withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: color.primary,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      locale.offer_checkout_applied_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size18,
                        color: color.primary,
                      ),
                    ),
                    if (args.offer.promoCode != null &&
                        args.offer.promoCode!.isNotEmpty) ...[
                      const SizedBox(height: Spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(Spacing.xs),
                        ),
                        child: Text(
                          '${locale.offer_checkout_applied_code}: ${args.offer.promoCode}',
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.primary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: Spacing.xs),
                    Text(
                      locale.offer_checkout_applied_description,
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Spacing.lg),

              // ── Order Summary Card ──
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: color.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Spacing.md),
                  border: Border.all(color: color.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.offer_checkout_order_summary_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size15,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    _buildRow(
                      context,
                      label: locale.offer_checkout_package_label,
                      value: args.packageName,
                    ),
                    const SizedBox(height: Spacing.sm),
                    _buildRow(
                      context,
                      label: locale.offer_checkout_meals_per_day,
                      value: '${args.mealsPerDay} ${locale.meals_count}',
                    ),
                    const SizedBox(height: Spacing.sm),
                    _buildRow(
                      context,
                      label: locale.offer_checkout_original_price,
                      value:
                          '${args.originalPriceKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
                    ),
                    const SizedBox(height: Spacing.sm),
                    _buildRow(
                      context,
                      label: locale.offer_checkout_discount_amount,
                      value:
                          '-${args.discountAmountKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
                      valueColor: color.primary,
                      isBold: true,
                    ),
                    const Divider(height: Spacing.xl),
                    _buildRow(
                      context,
                      label: locale.offer_checkout_final_total,
                      value:
                          '${args.finalPriceKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
                      valueColor: color.primary,
                      fontSize: FontSize.size17,
                      isBold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Spacing.lg),

              // ── Security Badges ──
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(Spacing.sm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, color: color.primary, size: 20),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      locale.offer_checkout_secure_badge,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Spacing.xl),

              // ── Primary Action: Proceed to Payment ──
              AppButton(
                text: locale.offer_checkout_proceed_button,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _handlePayment,
              ),

              const SizedBox(height: Spacing.md),

              // ── Secondary Action: Change Package ──
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  locale.offer_checkout_change_package_button,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    double? fontSize,
    bool isBold = false,
  }) {
    final color = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: fontSize ?? FontSize.size13,
            color: color.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: isBold
              ? getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: fontSize ?? FontSize.size13,
                  color: valueColor ?? color.onSurface,
                )
              : getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: fontSize ?? FontSize.size13,
                  color: valueColor ?? color.onSurface,
                ),
        ),
      ],
    );
  }
}
