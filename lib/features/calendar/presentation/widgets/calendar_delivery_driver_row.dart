import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryDriverRow extends StatelessWidget {
  const CalendarDeliveryDriverRow({
    super.key,
    required this.deliveryItem,
  });

  final CustomerDeliveryItemEntity deliveryItem;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final driver = deliveryItem.driver;
    final driverName = driver?.displayName(locale.localeName);
    final effectiveDriverName = (driverName != null && driverName.isNotEmpty)
        ? driverName
        : locale.calendar_delivery_default_driver_name;
    final rating = driver?.rating;
    final orderCode = deliveryItem.orderCode;

    return Row(
      children: [
        CircleAvatar(
          radius: Spacing.avatarSm / 2,
          backgroundColor: color.surfaceContainerHighest,
          backgroundImage: (driver?.avatarUrl != null && driver!.avatarUrl!.isNotEmpty)
              ? NetworkImage(driver.avatarUrl!)
              : null,
          child: (driver?.avatarUrl == null || driver!.avatarUrl!.isEmpty)
              ? Icon(
                  Icons.person_rounded,
                  color: color.onSurfaceVariant,
                  size: Spacing.iconSm,
                )
              : null,
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                effectiveDriverName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              if (orderCode != null && orderCode.isNotEmpty) ...[
                const SizedBox(height: Spacing.xxs),
                Text(
                  '${locale.calendar_delivery_order_code_label}: $orderCode',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (rating != null && rating > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xxs,
            ),
            decoration: BoxDecoration(
              color: color.surfaceContainerHighest.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  size: Spacing.iconSm,
                  color: color.primary,
                ),
                const SizedBox(width: Spacing.xxs),
                Text(
                  rating.toStringAsFixed(1),
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
