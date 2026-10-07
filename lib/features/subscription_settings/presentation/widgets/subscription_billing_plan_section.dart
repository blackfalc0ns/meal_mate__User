import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action_coordinator.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_empty_subscription_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_plan_card.dart';

class SubscriptionBillingPlanSection extends StatelessWidget {
  const SubscriptionBillingPlanSection({required this.coordinator, super.key});

  final SubscriptionBillingActionCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    return SubscriptionBillingEntrance(
      sectionKey: 'plan_summary',
      delay: Duration.zero,
      child:
          BlocSelector<
            SubscriptionBillingViewModel,
            SubscriptionBillingState,
            ({
              SubscriptionBillingSubscriptionEntity? subscription,
              SubscriptionBillingFreezePolicyEntity? freezePolicy,
              bool hasUncompleted,
              bool isActionLoading,
            })
          >(
            selector: (state) => (
              subscription: state.billing.data?.current.subscription,
              freezePolicy: state.billing.data?.freezePolicy,
              hasUncompleted:
                  state.billing.data?.uncompletedSubscriptions.isNotEmpty ==
                  true,
              isActionLoading: state.billingAction.isLoading,
            ),
            builder: (context, data) {
              final subscription = data.subscription;
              if (subscription == null) {
                return SubscriptionBillingEmptySubscriptionCard(
                  hasUncompletedSubscriptions: data.hasUncompleted,
                  onBrowseSubscriptions: () {
                    unawaited(
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.home,
                        (route) => false,
                        arguments: AppShellScreen.subscriptionsTabIndex,
                      ),
                    );
                  },
                );
              }

              return SubscriptionBillingPlanCard(
                subscription: subscription,
                isActionLoading: data.isActionLoading,
                onRenew: () => coordinator.confirmRenew(context, subscription),
                onFreeze: () => coordinator.confirmFreeze(
                  context: context,
                  subscription: subscription,
                  freezePolicy: data.freezePolicy,
                ),
                onCancel: () =>
                    coordinator.onCancelQuote(subscription.subscriptionId),
              );
            },
          ),
    );
  }
}
