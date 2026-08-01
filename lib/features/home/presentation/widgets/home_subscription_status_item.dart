import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

enum HomeSubscriptionStatusItemType {
  remainingDays,
  selectedMeals,
  commitment,
  nextDelivery,
}

class HomeSubscriptionStatusItem extends StatelessWidget {
  const HomeSubscriptionStatusItem({required this.type, super.key});

  final HomeSubscriptionStatusItemType type;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final icon = switch (type) {
      HomeSubscriptionStatusItemType.remainingDays =>
        Assets.homeSubscriptionDayCalendar,
      HomeSubscriptionStatusItemType.selectedMeals =>
        Assets.homeSubscriptionMeal,
      HomeSubscriptionStatusItemType.commitment => Assets.homeSubscriptionMedal,
      HomeSubscriptionStatusItemType.nextDelivery =>
        Assets.homeSubscriptionDelivery,
    };
    final label = switch (type) {
      HomeSubscriptionStatusItemType.remainingDays =>
        locale.home_remaining_days,
      HomeSubscriptionStatusItemType.selectedMeals =>
        locale.home_selected_meals,
      HomeSubscriptionStatusItemType.commitment => locale.home_commitment,
      HomeSubscriptionStatusItemType.nextDelivery => locale.home_next_delivery,
    };
    final value = switch (type) {
      HomeSubscriptionStatusItemType.remainingDays =>
        locale.home_subscription_days_value,
      HomeSubscriptionStatusItemType.selectedMeals =>
        locale.home_selected_meals_value,
      HomeSubscriptionStatusItemType.commitment => locale.home_commitment_value,
      HomeSubscriptionStatusItemType.nextDelivery => locale.home_tomorrow,
    };
    final subtitle = switch (type) {
      HomeSubscriptionStatusItemType.remainingDays =>
        locale.home_subscription_days_total_alt,
      HomeSubscriptionStatusItemType.selectedMeals => locale.home_meal,
      HomeSubscriptionStatusItemType.commitment =>
        locale.home_excellent_performance,
      HomeSubscriptionStatusItemType.nextDelivery => locale.home_before_noon,
    };
    return SizedBox(
      height: Spacing.homeSubscriptionStatusHeight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  icon,
                  width: Spacing.homeSubscriptionPlanIconSize,
                  height: Spacing.homeSubscriptionPlanIconSize,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  label,
                  maxLines: 1,
                  //  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: AppColors.black,
                    //color.onSecondaryContainer,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: Spacing.xs,
                bottom: Spacing.xs,
              ),
              child: Text(
                value,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size18,
                  color: color.onSecondaryContainer,
                ),
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
