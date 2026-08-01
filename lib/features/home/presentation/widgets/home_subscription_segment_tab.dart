import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

enum HomeSubscriptionSegmentTabType { subscription, nutrition }

class HomeSubscriptionSegmentTab extends StatelessWidget {
  const HomeSubscriptionSegmentTab({
    required this.type,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final HomeSubscriptionSegmentTabType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final foreground = isSelected ? color.onPrimary : color.primary;
    final icon = switch (type) {
      HomeSubscriptionSegmentTabType.subscription =>
        Assets.homeSubscriptionCalendar,
      HomeSubscriptionSegmentTabType.nutrition => Assets.homeSubscriptionHealth,
    };
    final label = switch (type) {
      HomeSubscriptionSegmentTabType.subscription =>
        locale.home_subscription_tab,
      HomeSubscriptionSegmentTabType.nutrition => locale.home_nutrition_tab,
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        Spacing.homeSubscriptionSegmentRadius,
      ),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? color.primary : color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(
            Spacing.homeSubscriptionSegmentRadius,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: Spacing.homeSubscriptionPlanIconSize,
              height: Spacing.homeSubscriptionPlanIconSize,
              colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: (isSelected ? getBoldStyle : getMediumStyle)(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
