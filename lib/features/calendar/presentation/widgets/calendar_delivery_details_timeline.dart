import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryDetailsTimeline extends StatelessWidget {
  const CalendarDeliveryDetailsTimeline({
    super.key,
    required this.deliveryItem,
  });

  final CustomerDeliveryItemEntity deliveryItem;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isDelivered = deliveryItem.isDelivered;
    final isArrived = isDelivered ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.arrived ||
        deliveryItem.hasArrived;
    final isOut = isArrived ||
        deliveryItem.isOutForDelivery ||
        deliveryItem.hasPickedUp;
    final isPrepared = isOut ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.ready ||
        deliveryItem.hasReady;

    final steps = [
      _TimelineStepData(
        title: locale.calendar_delivery_step_prepared,
        time: deliveryItem.readyAtUtc,
        isCompleted: isPrepared,
        isActive: deliveryItem.deliveryStatus == CustomerDeliveryStatus.preparing ||
            deliveryItem.deliveryStatus == CustomerDeliveryStatus.ready,
      ),
      _TimelineStepData(
        title: locale.calendar_delivery_step_out,
        time: deliveryItem.pickedUpAtUtc,
        isCompleted: isOut,
        isActive: deliveryItem.isOutForDelivery,
      ),
      _TimelineStepData(
        title: locale.calendar_delivery_step_arrived,
        time: deliveryItem.arrivedAtUtc,
        isCompleted: isArrived,
        isActive: deliveryItem.deliveryStatus == CustomerDeliveryStatus.arrived,
      ),
      _TimelineStepData(
        title: locale.calendar_delivery_step_delivered,
        time: deliveryItem.deliveredAtUtc,
        isCompleted: isDelivered,
        isActive: isDelivered,
      ),
    ];

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
            locale.calendar_delivery_timeline_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          for (int i = 0; i < steps.length; i++)
            _buildTimelineItem(
              step: steps[i],
              isLast: i == steps.length - 1,
              colorScheme: color,
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required _TimelineStepData step,
    required bool isLast,
    required ColorScheme colorScheme,
  }) {
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.outlineVariant;
    final timeStr = step.time != null ? _formatTime(step.time!) : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Spacing.lg,
                height: Spacing.lg,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.isCompleted
                      ? activeColor
                      : (step.isActive
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest),
                  border: Border.all(
                    color: step.isCompleted || step.isActive
                        ? activeColor
                        : inactiveColor,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  step.isCompleted
                      ? Icons.check_rounded
                      : (step.isActive
                          ? Icons.circle_rounded
                          : Icons.circle_outlined),
                  size: step.isCompleted ? Spacing.iconSm : Spacing.iconXs,
                  color: step.isCompleted
                      ? colorScheme.onPrimary
                      : (step.isActive
                          ? activeColor
                          : colorScheme.onSurfaceVariant),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: Spacing.xxs),
                    color: step.isCompleted ? activeColor : inactiveColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? Spacing.zero : Spacing.lg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    step.title,
                    style: step.isCompleted || step.isActive
                        ? getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: colorScheme.onSurface,
                          )
                        : getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                  ),
                  if (timeStr != null)
                    Text(
                      timeStr,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    try {
      return DateFormat('h:mm a').format(date.toLocal());
    } catch (_) {
      return '';
    }
  }
}

class _TimelineStepData {
  const _TimelineStepData({
    required this.title,
    this.time,
    required this.isCompleted,
    required this.isActive,
  });

  final String title;
  final DateTime? time;
  final bool isCompleted;
  final bool isActive;
}
