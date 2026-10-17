import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryTimeline extends StatelessWidget {
  const CalendarDeliveryTimeline({
    super.key,
    required this.deliveryItem,
  });

  final CustomerDeliveryItemEntity deliveryItem;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isDelivered = deliveryItem.isDelivered;
    final isOut = deliveryItem.isOutForDelivery ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.arrived ||
        isDelivered;
    final isPrepared = isOut ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.ready ||
        deliveryItem.hasReady;

    return Row(
      children: [
        _buildStep(
          label: locale.calendar_delivery_step_prepared,
          isCompleted: isPrepared,
          isActive: deliveryItem.deliveryStatus == CustomerDeliveryStatus.preparing ||
              deliveryItem.deliveryStatus == CustomerDeliveryStatus.ready,
          colorScheme: color,
        ),
        _buildDivider(isCompleted: isOut, colorScheme: color),
        _buildStep(
          label: locale.calendar_delivery_step_out,
          isCompleted: isOut,
          isActive: deliveryItem.isOutForDelivery ||
              deliveryItem.deliveryStatus == CustomerDeliveryStatus.arrived,
          colorScheme: color,
        ),
        _buildDivider(isCompleted: isDelivered, colorScheme: color),
        _buildStep(
          label: locale.calendar_delivery_step_delivered,
          isCompleted: isDelivered,
          isActive: isDelivered,
          colorScheme: color,
        ),
      ],
    );
  }

  Widget _buildStep({
    required String label,
    required bool isCompleted,
    required bool isActive,
    required ColorScheme colorScheme,
  }) {
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.outlineVariant;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Spacing.lg,
            height: Spacing.lg,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? activeColor
                  : (isActive
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest),
              border: Border.all(
                color: isCompleted || isActive ? activeColor : inactiveColor,
                width: 1.5,
              ),
            ),
            child: Icon(
              isCompleted
                  ? Icons.check_rounded
                  : (isActive ? Icons.circle_rounded : Icons.circle_outlined),
              size: isCompleted ? Spacing.iconSm : Spacing.iconXs,
              color: isCompleted
                  ? colorScheme.onPrimary
                  : (isActive ? activeColor : colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isCompleted || isActive
                ? getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: colorScheme.onSurface,
                  )
                : getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: colorScheme.onSurfaceVariant,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider({
    required bool isCompleted,
    required ColorScheme colorScheme,
  }) {
    return Container(
      width: Spacing.xl,
      height: 2.0,
      margin: const EdgeInsets.only(bottom: Spacing.base),
      color: isCompleted ? colorScheme.primary : colorScheme.outlineVariant,
    );
  }
}
