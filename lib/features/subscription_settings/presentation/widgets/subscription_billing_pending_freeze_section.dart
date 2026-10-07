import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action_coordinator.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_pending_freeze_card.dart';

class SubscriptionBillingPendingFreezeSection extends StatelessWidget {
  const SubscriptionBillingPendingFreezeSection({
    required this.coordinator,
    super.key,
  });

  final SubscriptionBillingActionCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      SubscriptionBillingViewModel,
      SubscriptionBillingState,
      ({
        SubscriptionBillingSubscriptionEntity? subscription,
        SubscriptionBillingPendingFreezeEntity? pendingFreeze,
        SubscriptionBillingFreezePolicyEntity? freezePolicy,
      })
    >(
      selector: (state) => (
        subscription: state.billing.data?.current.subscription,
        pendingFreeze: state.billing.data?.current.subscription?.pendingFreeze,
        freezePolicy: state.billing.data?.freezePolicy,
      ),
      builder: (context, data) {
        final pendingFreeze = data.pendingFreeze;
        final subscription = data.subscription;
        if (subscription == null || pendingFreeze == null) {
          return const SizedBox.shrink();
        }

        return SubscriptionBillingEntrance(
          sectionKey: 'pending_freeze',
          delay: const Duration(milliseconds: 40),
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.md),
            child: InkWell(
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
              onTap: () => coordinator.showPendingFreezeDialog(
                context: context,
                pendingFreeze: pendingFreeze,
                subscription: subscription,
                freezePolicy: data.freezePolicy,
              ),
              child: SubscriptionBillingPendingFreezeCard(
                pendingFreeze: pendingFreeze,
              ),
            ),
          ),
        );
      },
    );
  }
}
