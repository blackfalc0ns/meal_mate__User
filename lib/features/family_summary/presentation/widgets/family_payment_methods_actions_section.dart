import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_contract_constants.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_blocker_destination.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_payment_actions.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_payment_methods_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyPaymentMethodsActionsSection extends StatelessWidget {
  const FamilyPaymentMethodsActionsSection({super.key, required this.state});

  final FamilyCheckoutState state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyCheckoutViewModel, FamilyCheckoutState>(
      buildWhen: (prev, curr) =>
          prev.selectedPaymentMethod != curr.selectedPaymentMethod ||
          prev.paymentMethods != curr.paymentMethods ||
          prev.isPaymentMethodsLoading != curr.isPaymentMethodsLoading ||
          prev.isCheckoutLoading != curr.isCheckoutLoading ||
          prev.isRetryLoading != curr.isRetryLoading ||
          prev.summary?.canCheckout != curr.summary?.canCheckout ||
          prev.summary?.checkoutBlockReason !=
              curr.summary?.checkoutBlockReason ||
          prev.failure != curr.failure,
      builder: (context, activeState) {
        final paymentMethods = activeState.paymentMethods
            .map(
              (method) => FamilyPaymentMethodUiModel(
                label: method.title,
                imageAsset: '',
                selected: activeState.selectedPaymentMethod?.id == method.id,
              ),
            )
            .toList();

        return Column(
          children: [
            if (activeState.isPaymentMethodsLoading) ...[
              const SizedBox(height: Spacing.md),
              const SizedBox(
                height: Spacing.xxl,
                child: Center(
                  child: SizedBox(
                    height: Spacing.lg,
                    width: Spacing.lg,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ] else if (paymentMethods.isNotEmpty) ...[
              const SizedBox(height: Spacing.md),
              FamilyPaymentMethodsSection(
                methods: paymentMethods,
                onSelectMethod: (index) {
                  if (index < 0 || index >= activeState.paymentMethods.length) {
                    return;
                  }
                  context.read<FamilyCheckoutViewModel>().doIntent(
                    SelectFamilyPaymentMethodEvent(
                      activeState.paymentMethods[index],
                    ),
                  );
                },
              ),
            ] else if (activeState.failure != null &&
                (activeState.summary != null ||
                    activeState.currentFlow?.pendingCheckout != null)) ...[
              const SizedBox(height: Spacing.md),
              InlineApiErrorWidget(
                failure: activeState.failure!,
                onRetry: () {
                  final viewModel = context.read<FamilyCheckoutViewModel>();
                  if (activeState.failure?.code ==
                      SubscriptionErrorCodes.paymentInitializationFailed) {
                    final methodId =
                        activeState.selectedPaymentMethod?.id ?? 3;
                    viewModel.doIntent(
                      RetryFamilySubscriptionPaymentEvent(
                        callbackUrl: FamilyCheckoutContractConstants
                            .defaultSuccessCallbackUrl,
                        errorUrl: FamilyCheckoutContractConstants
                            .defaultErrorCallbackUrl,
                        correlationId: viewModel.correlationId,
                        paymentMethodId: methodId,
                      ),
                    );
                  } else {
                    viewModel.doIntent(
                      GetFamilySummaryEvent(
                        memberId: activeState.selectedSummaryMemberId,
                      ),
                    );
                  }
                },
              ),
            ],
            const SizedBox(height: Spacing.lg),
            () {
              final isPendingOrRetry =
                  activeState.summary?.checkoutBlockReason ==
                      SubscriptionErrorCodes.familyCheckoutPending ||
                  activeState.currentFlow?.isCheckoutPending == true ||
                  activeState.currentFlow?.canRetryPayment == true ||
                  activeState.failure?.code ==
                      SubscriptionErrorCodes.paymentInitializationFailed;
              final canCheckoutOrRetry =
                  (activeState.summary?.canCheckout == true) || isPendingOrRetry;

              return FamilyPaymentActions(
                canCheckout: canCheckoutOrRetry,
                isLoading:
                    activeState.isCheckoutLoading || activeState.isRetryLoading,
                isRetry: isPendingOrRetry,
                checkoutBlockReason: isPendingOrRetry
                    ? null
                    : activeState.summary?.checkoutBlockReason,
                onResolveBlocker: () {
                  final route = familyCheckoutBlockerRoute(
                    activeState.summary?.checkoutBlockReason,
                  );
                  if (route != null) {
                    unawaited(context.pushReplacementNamed(route));
                  }
                },
                onConfirmPayment: () {
                  final methodId = activeState.selectedPaymentMethod?.id ?? 3;
                  final viewModel = context.read<FamilyCheckoutViewModel>();
                  viewModel.doIntent(
                    isPendingOrRetry
                        ? RetryFamilySubscriptionPaymentEvent(
                            callbackUrl: FamilyCheckoutContractConstants
                                .defaultSuccessCallbackUrl,
                            errorUrl: FamilyCheckoutContractConstants
                                .defaultErrorCallbackUrl,
                            correlationId: viewModel.correlationId,
                            paymentMethodId: methodId,
                          )
                        : CheckoutFamilySubscriptionEvent(
                            callbackUrl: FamilyCheckoutContractConstants
                                .defaultSuccessCallbackUrl,
                            errorUrl: FamilyCheckoutContractConstants
                                .defaultErrorCallbackUrl,
                            correlationId: viewModel.correlationId,
                            paymentMethodId: methodId,
                          ),
                  );
                },
              );
            }(),
          ],
        );
      },
    );
  }
}
