import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_order_summary_card.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_footer.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_loading_skeleton.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_method_selector.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, this.args});

  final PaymentArgs? args;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final paymentArgs = args;

    if (paymentArgs == null) {
      return Scaffold(
        appBar: CustomAppBar(title: l10n.payment_title),
        body: EmptyStateWidget(
          title: l10n.payment_title,
          description: l10n.subscription_program_subtitle,
          icon: Icons.payment_rounded,
        ),
      );
    }

    return BlocProvider<PaymentViewModel>(
      create: (_) =>
          getIt<PaymentViewModel>()..doIntent(LoadPaymentEvent(paymentArgs)),
      child: BlocConsumer<PaymentViewModel, PaymentState>(
        listenWhen: (previous, current) =>
            previous.checkout != current.checkout ||
            previous.checkoutFailure != current.checkoutFailure,
        listener: (context, state) async {
          final checkout = state.checkout;
          if (checkout != null && checkout.paymentUrl.isNotEmpty) {
            Navigator.of(context).pushNamed(
              AppRoutes.paymentWebView,
              arguments: PaymentWebViewArgs(checkout: checkout),
            );
            return;
          }

          final checkoutFailure = state.checkoutFailure;
          if (checkoutFailure != null) {
            await _handleCheckoutFailure(
              context,
              paymentArgs,
              checkoutFailure.code,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: l10n.payment_title),
            body: _buildBody(context, paymentArgs, state),
            bottomNavigationBar: PaymentFooter(
              totalAmount: paymentArgs.summary.finalPrice,
              isLoading: state.isCheckoutLoading,
              onPayNow: _canPayNow(state)
                  ? () => _handlePayNow(context, paymentArgs, state)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PaymentArgs paymentArgs,
    PaymentState state,
  ) {
    final l10n = context.localization;
    final localeName = l10n.localeName;

    if (state.isLoading && !state.hasContent) {
      return const PaymentLoadingSkeleton();
    }

    if (state.methodsFailure != null && !state.hasContent) {
      return ApiErrorWidget(
        exception: state.methodsFailure!.exception,
        onRetry: () => context.read<PaymentViewModel>().doIntent(
          LoadPaymentEvent(paymentArgs),
        ),
      );
    }

    if (state.methods.isEmpty) {
      return EmptyStateWidget(
        title: l10n.payment_method_section_title,
        description: l10n.payment_secure_label,
        icon: Icons.payment_rounded,
      );
    }

    final selectedMethodId = state.selectedMethod?.id ?? state.methods.first.id;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 8, bottom: 18),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
                child: AppOrderSummaryCard(
                  planTitle: paymentArgs.summary.bundleName(localeName),
                  planDuration:
                      '${paymentArgs.summary.durationDays} ${l10n.subscription_day}',
                  mealsPerDay: paymentArgs.summary.programName(localeName),
                  originalPrice: paymentArgs.summary.finalPrice.toStringAsFixed(
                    3,
                  ),
                  discountAmount:
                      (paymentArgs.summary.campaignDiscount +
                              paymentArgs.summary.promoDiscount +
                              paymentArgs.summary.walletCredit)
                          .toStringAsFixed(3),
                  totalPrice: paymentArgs.summary.finalPrice.toStringAsFixed(3),
                  imageAsset: Assets.monthlyPlanHero,
                  imageUrl: paymentArgs.summary.imageUrl,
                  couponHint: l10n.payment_coupon_hint,
                ),
              ),
              const SizedBox(height: 16),
              PaymentMethodSelector(
                methods: state.methods,
                selectedMethodId: selectedMethodId,
                onMethodSelected: (method) => context
                    .read<PaymentViewModel>()
                    .doIntent(SelectPaymentMethodEvent(method)),
              ),
              if (state.checkoutFailure != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.base,
                    vertical: Spacing.md,
                  ),
                  child: ApiErrorWidget(
                    exception: state.checkoutFailure!.exception,
                    onRetry: state.isCheckoutLoading
                        ? null
                        : () => context.read<PaymentViewModel>().doIntent(
                            CheckoutPaymentEvent(paymentArgs),
                          ),
                  ),
                ),
              const SizedBox(height: Spacing.base),
            ]),
          ),
        ),
      ],
    );
  }

  void _handlePayNow(
    BuildContext context,
    PaymentArgs args,
    PaymentState state,
  ) {
    if (state.isCheckoutLoading) return;

    context.read<PaymentViewModel>().doIntent(CheckoutPaymentEvent(args));
  }

  bool _canPayNow(PaymentState state) {
    if (state.checkoutFailure?.code == 'checkout.existing_subscription') {
      return false;
    }

    return true;
  }

  Future<void> _handleCheckoutFailure(
    BuildContext context,
    PaymentArgs args,
    String code,
  ) async {
    final route = switch (code) {
      'checkout.address_required' => AppRoutes.addressChooseLocation,
      'checkout.allergies_required' => AppRoutes.addAllergy,
      'checkout.dietary_preferences_required' => AppRoutes.dietaryPreferences,
      'restaurant.not_eligible' => AppRoutes.addressChooseLocation,
      'subscription_flow.no_restaurants_for_address' =>
        AppRoutes.addressChooseLocation,
      'checkout.no_restaurants_for_address' => AppRoutes.addressChooseLocation,
      _ => null,
    };

    if (route == null) {
      return;
    }

    final updated = await Navigator.of(context).pushNamed(
      route,
      arguments: SubscriptionFlowArgs(request: args.summaryRequest),
    );

    if (updated == true && context.mounted) {
      context.read<PaymentViewModel>().doIntent(CheckoutPaymentEvent(args));
    }
  }
}
