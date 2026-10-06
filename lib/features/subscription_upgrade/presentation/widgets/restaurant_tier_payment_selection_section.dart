import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_payment_section.dart';

class RestaurantTierPaymentSelectionSection extends StatelessWidget {
  const RestaurantTierPaymentSelectionSection({
    super.key,
    required this.onPaymentMethodSelected,
  });

  final ValueChanged<SubscriptionUpgradePaymentMethodEntity>
      onPaymentMethodSelected;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      RestaurantTierUpgradeViewModel,
      RestaurantTierUpgradeState,
      ({
        List<SubscriptionUpgradePaymentMethodEntity> methods,
        SubscriptionUpgradePaymentMethodEntity? selected,
      })
    >(
      selector: (state) => (
        methods: state.upgradeSummary?.paymentMethods ?? const [],
        selected: state.selectedPaymentMethod,
      ),
      builder: (context, data) {
        if (data.methods.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            const SizedBox(height: Spacing.lg),
            RestaurantTierPaymentSection(
              title: locale.restaurant_tier_payment_method_title,
              paymentMethods: data.methods,
              selectedPaymentMethod: data.selected,
              onPaymentMethodSelected: onPaymentMethodSelected,
            ),
          ],
        );
      },
    );
  }
}
