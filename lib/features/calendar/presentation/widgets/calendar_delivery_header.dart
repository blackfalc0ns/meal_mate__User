import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryHeader extends StatelessWidget {
  const CalendarDeliveryHeader({
    super.key,
    required this.deliveryItem,
  });

  final CustomerDeliveryItemEntity deliveryItem;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final title = _resolveTitle(locale);
    final isDelivered = deliveryItem.isDelivered;
    final etaMinutes = deliveryItem.etaMinutes;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                isDelivered
                    ? Icons.check_circle_rounded
                    : Icons.local_shipping_rounded,
                color: color.primary,
                size: Spacing.iconMd,
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (etaMinutes != null && !isDelivered)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xxs,
            ),
            decoration: BoxDecoration(
              color: color.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  size: Spacing.iconSm,
                  color: color.primary,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.calendar_delivery_eta_format(etaMinutes.toString()),
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          )
        else if (isDelivered)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xxs,
            ),
            decoration: BoxDecoration(
              color: color.primaryContainer.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: Spacing.iconSm,
                  color: color.primary,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.calendar_delivery_step_delivered,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _resolveTitle(dynamic locale) {
    if (deliveryItem.isDelivered) {
      return locale.calendar_delivery_title_delivered;
    }
    if (deliveryItem.isOutForDelivery) {
      return locale.calendar_delivery_title_out_for_delivery;
    }
    return switch (deliveryItem.deliveryStatus) {
      CustomerDeliveryStatus.preparing =>
        locale.calendar_delivery_title_preparing,
      CustomerDeliveryStatus.scheduled =>
        locale.calendar_delivery_title_scheduled,
      CustomerDeliveryStatus.arrived =>
        locale.calendar_delivery_title_arrived,
      CustomerDeliveryStatus.failed =>
        locale.calendar_delivery_title_failed,
      _ => deliveryItem.localizedStatus(locale.localeName),
    };
  }
}
