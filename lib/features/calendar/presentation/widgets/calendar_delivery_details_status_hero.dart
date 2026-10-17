import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryDetailsStatusHero extends StatelessWidget {
  const CalendarDeliveryDetailsStatusHero({
    super.key,
    required this.deliveryItem,
  });

  final CustomerDeliveryItemEntity deliveryItem;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isDelivered = deliveryItem.isDelivered;
    final title = isDelivered
        ? locale.calendar_delivery_delivered_success_title
        : deliveryItem.localizedStatus(locale.localeName);

    final deliveredAt = deliveryItem.deliveredAtUtc;
    final timeStr = deliveredAt != null
        ? _formatTime(deliveredAt, locale.localeName)
        : null;
    final addressStr = deliveryItem.destinationAddress ?? '';

    final subtitle = isDelivered
        ? (timeStr != null && addressStr.isNotEmpty
            ? locale.calendar_delivery_delivered_at_format(timeStr, addressStr)
            : addressStr)
        : addressStr;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (final angle in const [0.0, 45.0, 90.0, 135.0])
                Transform.rotate(
                  angle: angle * (3.141592653589793 / 180.0),
                  child: SizedBox(
                    height: 76,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 3.5,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color.primary.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(Spacing.xxs),
                          ),
                        ),
                        Container(
                          width: 3.5,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color.primary.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(Spacing.xxs),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.primary,
                ),
                child: Icon(
                  isDelivered
                      ? Icons.check_rounded
                      : Icons.local_shipping_rounded,
                  color: color.onPrimary,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.base),
        Text(
          title,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size20,
            color: color.onSurface,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: Spacing.xs),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime date, String localeCode) {
    try {
      return DateFormat('h:mm a', localeCode).format(date.toLocal());
    } catch (_) {
      return '';
    }
  }
}
