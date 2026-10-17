import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_box_badge.dart';

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

    return Row(
      children: [
        Container(
          width: Spacing.xl,
          height: Spacing.xl,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.onPrimary.withValues(alpha: 0.15),
          ),
          child: Icon(
            Icons.local_shipping_rounded,
            color: color.onPrimary,
            size: Spacing.iconXs,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onPrimary,
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        const CalendarDeliveryBoxBadge(isDarkBackground: true),
      ],
    );
  }

  String _resolveTitle(dynamic locale) {
    if (deliveryItem.isDelivered) {
      return locale.calendar_delivery_title_delivered;
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
      _ => locale.calendar_delivery_title_out_for_delivery,
    };
  }
}
