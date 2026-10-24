import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';

class DeliveredOrderCard extends StatelessWidget {
  const DeliveredOrderCard({
    super.key,
    required this.box,
    required this.onTap,
  });

  final DeliveredBoxEntity box;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final restaurantTitle = box.restaurantNameAr?.trim().isNotEmpty == true
        ? box.restaurantNameAr!
        : (box.restaurantNameEn?.trim().isNotEmpty == true
            ? box.restaurantNameEn!
            : locale.customer_orders_delivered_box);

    final parsedUtc = box.deliveredAtUtc != null
        ? DateTime.tryParse(box.deliveredAtUtc!)?.toLocal()
        : null;

    final dateFormatted = parsedUtc != null
        ? intl.DateFormat.yMMMd(locale.localeName).format(parsedUtc)
        : box.serviceDate;

    final timeFormatted = parsedUtc != null
        ? intl.DateFormat.jm(locale.localeName).format(parsedUtc)
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.md,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Restaurant Name & Delivered Badge
              Row(
                children: [
                  Container(
                    width: Spacing.avatarSm,
                    height: Spacing.avatarSm,
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.restaurant_rounded,
                      size: Spacing.iconSm,
                      color: color.primary,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      restaurantTitle,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: Spacing.iconXs,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          locale.customer_orders_status_delivered,
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
              ),

              // Order Code Badge (LTR isolated)
              if (box.orderCode != null &&
                  box.orderCode!.trim().isNotEmpty) ...[
                const SizedBox(height: Spacing.sm),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    ),
                    child: Text(
                      box.orderCode!,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: Spacing.sm),

              // Meta row: Date/Time & Box Count
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: Spacing.iconSm,
                    color: color.onSurfaceVariant,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Text(
                      timeFormatted != null
                          ? '$dateFormatted • $timeFormatted'
                          : dateFormatted,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Icon(
                    Icons.inventory_2_outlined,
                    size: Spacing.iconSm,
                    color: color.onSurfaceVariant,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    locale.customer_orders_box_count(box.boxCount ?? 1),
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Spacing.sm),
              Divider(
                color: color.outlineVariant.withValues(alpha: 0.4),
                height: Spacing.sm,
              ),
              const SizedBox(height: Spacing.xs),

              // Footer: View Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.customer_orders_view_details,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.primary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: Spacing.iconXs,
                    color: color.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
