import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_screen_args.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/create_campaign_checkout_session_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/offer_checkout_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/promo_checkout/promo_applied_banner.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/promo_checkout/promo_checkout_actions_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/promo_checkout/promo_order_summary_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/promo_checkout/promo_security_badge.dart';

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
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      if (widget.args.offer.campaignId != null &&
          widget.args.offer.campaignId!.isNotEmpty) {
        final sessionUseCase = getIt<CreateCampaignCheckoutSessionUseCase>();
        final sessionResult = await sessionUseCase(
          campaignId: widget.args.offer.campaignId!,
          bundleId:
              widget.args.bundleId ?? 'a1b2c3d4-e5f6-7890-1234-567890abcdef',
          durationDays: widget.args.durationDays,
          deliveryGovernorate: widget.args.deliveryGovernorate,
        );

        if (!mounted) return;

        switch (sessionResult) {
          case ApiSuccessResult(:final data):
            await Navigator.of(context).pushNamed(
              AppRoutes.campaignPayment,
              arguments: CampaignPaymentScreenArgs(
                sessionId: data.sessionId,
                amount: data.finalCustomerPrice,
                currency: data.currency,
                offer: widget.args.offer,
              ),
            );
            return;
          case ApiErrorResult(:final failure):
            final message = ErrorMessagePresenter.fromFailure(context, failure);
            CustomSnackbar.showError(context: context, message: message);
            return;
        }
      }

      final programId = widget.args.programId;
      final bundleId = widget.args.bundleId;

      if (programId == null ||
          programId.isEmpty ||
          bundleId == null ||
          bundleId.isEmpty) {
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.subscriptionProgramSelection);
        return;
      }

      final checkoutUseCase = getIt<CheckoutSubscriptionUseCase>();
      final request = PaymentCheckoutRequestEntity(
        programId: programId,
        bundleId: bundleId,
        tier: widget.args.tier ?? '0',
        durationDays: widget.args.durationDays,
        startDate: DateTime.now()
            .add(const Duration(days: 1))
            .toIso8601String()
            .split('T')
            .first,
        callbackUrl: 'https://maelmate.runasp.net/payment/callback',
        errorUrl: 'https://maelmate.runasp.net/payment/error',
        includeFriday: false,
        paymentMethodId: 1,
        correlationId: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      final result = await checkoutUseCase(request);

      if (!mounted) return;

      switch (result) {
        case ApiSuccessResult(:final data):
          await Navigator.of(context).pushNamed(
            AppRoutes.paymentWebView,
            arguments: PaymentWebViewArgs(checkout: data),
          );
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
              PromoAppliedBanner(promoCode: widget.args.offer.promoCode),
              const SizedBox(height: Spacing.lg),
              PromoOrderSummaryCard(args: widget.args),
              const SizedBox(height: Spacing.lg),
              const PromoSecurityBadge(),
              const SizedBox(height: Spacing.xl),
              PromoCheckoutActionsSection(
                isLoading: _isLoading,
                onProceed: _handlePayment,
                onChangePackage: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
