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
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locale.calendar_delivery_info_section_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          _buildInfoRow(
            label: locale.calendar_delivery_driver_label,
            valueWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: Spacing.avatarSm / 2,
                  backgroundColor: color.surfaceContainerHighest,
                  backgroundImage: (driver?.avatarUrl != null &&
                          driver!.avatarUrl!.isNotEmpty)
                      ? NetworkImage(driver.avatarUrl!)
                      : null,
                  child: (driver?.avatarUrl == null ||
                          driver!.avatarUrl!.isEmpty)
                      ? Icon(
                          Icons.person_rounded,
                          size: Spacing.iconSm,
                          color: color.onSurfaceVariant,
                        )
                      : null,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  effectiveDriverName,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                if (driver?.rating != null && driver!.rating! > 0) ...[
                  const SizedBox(width: Spacing.xs),
                  Icon(
                    Icons.star_rounded,
                    size: Spacing.iconSm,
                    color: color.primary,
                  ),
                  Text(
                    driver.rating!.toStringAsFixed(1),
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            colorScheme: color,
          ),
          const Divider(height: Spacing.xl),
          _buildInfoRow(
            label: locale.calendar_delivery_method_label,
            valueWidget: Text(
              effectiveMethod,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
            colorScheme: color,
          ),
          const Divider(height: Spacing.xl),
          _buildInfoRow(
            label: locale.calendar_delivery_order_code_label,
            valueWidget: Text(
              orderCode,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
            colorScheme: color,
          ),
          const Divider(height: Spacing.xl),
          _buildInfoRow(
            label: locale.calendar_delivery_date_label,
            valueWidget: Text(
              dateStr,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
            colorScheme: color,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required Widget valueWidget,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        valueWidget,
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
