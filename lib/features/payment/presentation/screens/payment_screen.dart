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
            previous.checkout != current.checkout,
        listener: (context, state) {
          if (state.checkout != null) {
            Navigator.of(context).pushNamed(AppRoutes.paymentSuccess);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: l10n.payment_title),
            body: _buildBody(context, paymentArgs, state),
            bottomNavigationBar: PaymentFooter(
              totalAmount: paymentArgs.summary.finalPrice,
              isLoading: state.isCheckoutLoading,
              onPayNow: _canCheckout(paymentArgs, state)
                  ? () => context.read<PaymentViewModel>().doIntent(
                      CheckoutPaymentEvent(
                        args: paymentArgs,
                        address: state.defaultAddress!,
                      ),
                    )
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
                    onRetry: _canCheckout(paymentArgs, state)
                        ? () => context.read<PaymentViewModel>().doIntent(
                            CheckoutPaymentEvent(
                              args: paymentArgs,
                              address: state.defaultAddress!,
                            ),
                          )
                        : null,
                  ),
                ),
              const SizedBox(height: Spacing.base),
            ]),
          ),
        ),
      ],
    );
  }

  bool _canCheckout(PaymentArgs args, PaymentState state) {
    final address = state.defaultAddress;
    return state.selectedMethod != null &&
        args.restaurantId.isNotEmpty &&
        args.summary.startDate.isNotEmpty &&
        address != null &&
        (address.regionId?.isNotEmpty ?? false) &&
        address.addressLine.isNotEmpty &&
        !state.isCheckoutLoading;
  }
}
