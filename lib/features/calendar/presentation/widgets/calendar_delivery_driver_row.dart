import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryDriverRow extends StatelessWidget {
  const CalendarDeliveryDriverRow({super.key, required this.deliveryItem});

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
    final rating = (driver?.rating != null && driver!.rating! > 0)
        ? driver.rating!.toStringAsFixed(1)
        : '4.9';
    final etaMinutes = deliveryItem.etaMinutes ?? 18;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Spacing.avatarSm,
              height: Spacing.avatarSm,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.onPrimary.withValues(alpha: 0.8),
                  width: Spacing.border,
                ),
                color: color.surfaceContainerHighest,
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  (driver?.avatarUrl != null && driver!.avatarUrl!.isNotEmpty)
                  ? Image.network(
                      driver.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Image.asset(
                        AssetsFake.callingDriverAvatar,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      AssetsFake.callingDriverAvatar,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: Spacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.calendar_delivery_driver_role,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
                Text(
                  effectiveDriverName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onPrimary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: Spacing.iconXs,
                      color: color.secondary,
                    ),
                    const SizedBox(width: Spacing.xxs),
                    Text(
                      rating,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.calendar_delivery_arrives_in_prefix,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: Spacing.xxs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  color: color.secondary,
                  size: Spacing.iconSm,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.calendar_delivery_minutes_suffix(
                    etaMinutes.toString(),
                  ),
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size15,
                    color: color.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
