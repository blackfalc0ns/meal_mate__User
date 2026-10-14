import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action_coordinator.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_uncompleted_subscription_card.dart';

class SubscriptionBillingUncompletedSection extends StatelessWidget {
  const SubscriptionBillingUncompletedSection({
    required this.coordinator,
    super.key,
  });

  final SubscriptionBillingActionCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocSelector<
      SubscriptionBillingViewModel,
      SubscriptionBillingState,
      ({
        List<SubscriptionBillingUncompletedSubscriptionEntity> list,
        bool isActionLoading,
        String? actionSubId,
      })
    >(
      selector: (state) => (
        list: state.billing.data?.uncompletedSubscriptions ?? const [],
        isActionLoading: state.billingAction.isLoading,
        actionSubId: state.billingAction.subscriptionId,
      ),
      builder: (context, data) {
        if (data.list.isEmpty) {
          return const SizedBox.shrink();
        }

        return SubscriptionBillingEntrance(
          sectionKey: 'unfinished_subscriptions',
          delay: const Duration(milliseconds: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.lg),
              Text(
                locale.billing_uncompleted_title,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size15,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              for (final item in data.list) ...[
                SubscriptionBillingUncompletedSubscriptionCard(
                  subscription: item,
                  isLoading:
                      data.isActionLoading &&
                      data.actionSubId == item.subscriptionId,
                  onDelete: () =>
                      coordinator.confirmDeleteUncompleted(context, item),
                  onResume: () => item.kind.toUpperCase() == 'FAMILY'
                      ? coordinator.onResumeFamily(item)
                      : coordinator.onResumePreview(item.subscriptionId),
                ),
                const SizedBox(height: Spacing.sm),
              ],
            ],
          ),
        );
      },
    );
  }
}
