import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryDetailsInfoCard extends StatelessWidget {
  const CalendarDeliveryDetailsInfoCard({
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

    final vehicleLabel = deliveryItem.vehicle?.displayLabel(locale.localeName);
    final effectiveMethod = (vehicleLabel != null && vehicleLabel.isNotEmpty)
        ? vehicleLabel
        : locale.calendar_delivery_direct_delivery;

    final orderCode = deliveryItem.orderCode ?? '-';
    final dateStr = _formatDate(
      deliveryItem.deliveredAtUtc ?? deliveryItem.readyAtUtc ?? DateTime.now(),
      locale.localeName,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.base),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.article_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.calendar_delivery_info_section_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          _buildInfoRow(
            icon: Icons.person_rounded,
            label: locale.calendar_delivery_driver_label,
            value: effectiveDriverName,
            colorScheme: color,
          ),
          Divider(
            height: Spacing.lg,
            thickness: 0.5,
            color: color.outlineVariant.withValues(alpha: 0.35),
          ),
          _buildInfoRow(
            icon: Icons.door_front_door_rounded,
            label: locale.calendar_delivery_method_label,
            value: effectiveMethod,
            colorScheme: color,
          ),
          Divider(
            height: Spacing.lg,
            thickness: 0.5,
            color: color.outlineVariant.withValues(alpha: 0.35),
          ),
          _buildInfoRow(
            icon: Icons.tag_rounded,
            label: locale.calendar_delivery_order_code_label,
            value: orderCode,
            colorScheme: color,
          ),
          Divider(
            height: Spacing.lg,
            thickness: 0.5,
            color: color.outlineVariant.withValues(alpha: 0.35),
          ),
          _buildInfoRow(
            icon: Icons.calendar_month_rounded,
            label: locale.calendar_delivery_date_label,
            value: dateStr,
            colorScheme: color,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: Spacing.iconSm,
              color: colorScheme.primary,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date, String localeCode) {
    try {
      return DateFormat('d MMMM، yyyy', localeCode).format(date.toLocal());
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(date.toLocal());
    }
  }
}
