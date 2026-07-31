import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_delivery_card.dart';

class HomeDeliveryCards extends StatelessWidget {
  const HomeDeliveryCards({
    super.key,
    required this.calendarLabel,
    required this.nextBoxLabel,
    required this.detailsLabel,
    required this.deliveryTime,
  });

  final String calendarLabel;
  final String nextBoxLabel;
  final String detailsLabel;
  final String deliveryTime;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.homeHorizontalPadding,
      ),
      child: ColoredBox(
        color: color.surface,
        child: SizedBox(
          height: Spacing.homeInfoCardHeight,
          child: Row(
            children: [
              Expanded(
                child: HomeDeliveryCard(
                  image: Assets.homeDeliveryBox,
                  title: nextBoxLabel,
                  subtitle: deliveryTime,
                  action: detailsLabel,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: HomeDeliveryCard(
                  image: Assets.homeCalendar,
                  title: locale.home_calendar_card_title,
                  subtitle: locale.home_calendar_card_subtitle,
                  action: calendarLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
