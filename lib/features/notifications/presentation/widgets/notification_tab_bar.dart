import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';

class NotificationTabBar extends StatelessWidget {
  const NotificationTabBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final NotificationCategory selectedCategory;
  final ValueChanged<NotificationCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final tabs = [
      (NotificationCategory.all, locale.notifications_tab_all),
      (
        NotificationCategory.subscription,
        locale.notifications_tab_subscription,
      ),
      (NotificationCategory.meals, locale.notifications_tab_meals),
      (NotificationCategory.system, locale.notifications_tab_system),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Row(
          children: tabs.map((tab) {
            final isSelected = selectedCategory == tab.$1;
            return InkWell(
              onTap: () => onCategorySelected(tab.$1),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: Spacing.sm,
                  end: Spacing.sm,
                  top: Spacing.xss,
                  bottom: Spacing.xss,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tab.$2,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontSize: 12.5,
                        color: isSelected
                            ? color.primary
                            : color.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Container(
                      height: 2,
                      width: isSelected ? 28 : 0,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.primary
                            : color.surface.withValues(alpha: 0),
                        borderRadius: BorderRadius.circular(Spacing.radiusXs),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
