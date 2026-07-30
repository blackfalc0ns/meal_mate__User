import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeDeliveryCards extends StatelessWidget {
  const HomeDeliveryCards({
    super.key,
    required this.calendarLabel,
    required this.nextBoxLabel,
    required this.detailsLabel,
    required this.deliveryTime,
  });
  final String calendarLabel, nextBoxLabel, detailsLabel, deliveryTime;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.homeHorizontalPadding,
      ),
      child: SizedBox(
        height: Spacing.homeInfoCardHeight,
        child: Row(
          children: [
            Expanded(
              child: _DeliveryCard(
                color: color,
                image: Assets.homeDeliveryBox,
                title: nextBoxLabel,
                subtitle: deliveryTime,
                action: detailsLabel,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: _DeliveryCard(
                color: color,
                image: Assets.homeCalendar,
                title: 'التقويم',
                subtitle: 'استعرض وجباتك القادمة',
                action: calendarLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({
    required this.color,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.action,
  });
  final ColorScheme color;
  final String image, title, subtitle, action;
  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Card(
      color: color.primaryContainer,
      child: Stack(
        children: [
          PositionedDirectional(
            end: 0,
            child: Image.asset(image, height: Spacing.homeInfoCardHeight),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: color.primary),
                ),
                const Spacer(),
                Text(
                  action,
                  style: AppTextStyles.caption.copyWith(color: color.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
