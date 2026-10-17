import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryInfoRow extends StatelessWidget {
  const CalendarDeliveryInfoRow({
    super.key,
    required this.deliveryItem,
    this.isDarkVariant = true,
  });

  final CustomerDeliveryItemEntity deliveryItem;
  final bool isDarkVariant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final orderCode =
        (deliveryItem.orderCode != null && deliveryItem.orderCode!.isNotEmpty)
        ? deliveryItem.orderCode!
        : (deliveryItem.subscriptionDayId ?? '-');
    final vehicleLabel = deliveryItem.vehicle?.displayLabel(locale.localeName);
    final effectiveMethod = (vehicleLabel != null && vehicleLabel.isNotEmpty)
        ? vehicleLabel
        : locale.calendar_delivery_direct_delivery;

    final labelColor = isDarkVariant
        ? color.onPrimary.withValues(alpha: 0.75)
        : color.onSurfaceVariant;
    final valueColor = isDarkVariant ? color.onPrimary : color.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 1,
          thickness: 1,
          color: isDarkVariant
              ? color.onPrimary.withValues(alpha: 0.15)
              : color.outlineVariant.withValues(alpha: 0.5),
        ),
        const SizedBox(height: Spacing.xs),
        Row(
          children: [
            // Order Code
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    Assets.homeDeliveryBox,
                    width: Spacing.iconMd,
                    height: Spacing.iconMd,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          locale.calendar_delivery_order_code_label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: labelColor,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          orderCode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: valueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 22,
              color: isDarkVariant
                  ? color.onPrimary.withValues(alpha: 0.2)
                  : color.outlineVariant.withValues(alpha: 0.5),
            ),
            // Delivery Method
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          locale.calendar_delivery_method_label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: labelColor,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          effectiveMethod,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: valueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Icon(
                    Icons.local_shipping_outlined,
                    color: isDarkVariant ? color.onPrimary : color.primary,
                    size: Spacing.iconMd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
