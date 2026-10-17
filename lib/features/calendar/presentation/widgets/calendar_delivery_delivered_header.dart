import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_box_badge.dart';

class CalendarDeliveryDeliveredHeader extends StatelessWidget {
  const CalendarDeliveryDeliveredHeader({
    super.key,
    required this.deliveryItem,
  });

  final CustomerDeliveryItemEntity deliveryItem;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final deliveredTime = _formatDeliveredTime(
      deliveryItem.deliveredAtUtc,
      locale.localeName,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: color.primary,
          size: Spacing.iconLg,
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                locale.calendar_delivery_step_delivered,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                locale.calendar_delivery_photo_at_door,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              if (deliveredTime.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: color.onSurfaceVariant,
                      size: Spacing.iconXs,
                    ),
                    const SizedBox(width: Spacing.xxs),
                    Text(
                      locale.calendar_delivery_delivered_today_format(deliveredTime),
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(width: Spacing.sm),
        const CalendarDeliveryBoxBadge(isDarkBackground: false),
      ],
    );
  }

  String _formatDeliveredTime(DateTime? date, String localeCode) {
    if (date == null) {
      return '';
    }
    try {
      return DateFormat('h:mm a', localeCode).format(date.toLocal());
    } catch (_) {
      return '';
    }
  }
}
