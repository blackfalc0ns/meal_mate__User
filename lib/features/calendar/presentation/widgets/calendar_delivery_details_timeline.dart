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
    final isOut = isDelivered ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.arrived ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.outForDelivery ||
        deliveryItem.hasArrived ||
        deliveryItem.hasPickedUp;
    final isPrepared = isOut ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.ready ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.preparing ||
        deliveryItem.hasReady;

    final time1 = deliveryItem.readyAtUtc != null
        ? _formatTime(deliveryItem.readyAtUtc!, locale.localeName)
        : '';
    final time2 = deliveryItem.pickedUpAtUtc != null
        ? _formatTime(deliveryItem.pickedUpAtUtc!, locale.localeName)
        : '';
    final time3 = deliveryItem.deliveredAtUtc != null
        ? _formatTime(deliveryItem.deliveredAtUtc!, locale.localeName)
        : '';

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
                Icons.access_time_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.calendar_delivery_timeline_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildStepItem(
                  title: locale.calendar_delivery_step_prepared,
                  time: time1,
                  isCompleted: isPrepared,
                  hasLineStart: false,
                  hasLineEnd: true,
                  isLineStartCompleted: false,
                  isLineEndCompleted: isOut,
                  colorScheme: color,
                ),
              ),
              Expanded(
                child: _buildStepItem(
                  title: locale.calendar_delivery_step_out,
                  time: time2,
                  isCompleted: isOut,
                  hasLineStart: true,
                  hasLineEnd: true,
                  isLineStartCompleted: isOut,
                  isLineEndCompleted: isDelivered,
                  colorScheme: color,
                ),
              ),
              Expanded(
                child: _buildStepItem(
                  title: locale.calendar_delivery_step_delivered,
                  time: time3,
                  isCompleted: isDelivered,
                  hasLineStart: true,
                  hasLineEnd: false,
                  isLineStartCompleted: isDelivered,
                  isLineEndCompleted: false,
                  colorScheme: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String title,
    required String time,
    required bool isCompleted,
    required bool hasLineStart,
    required bool hasLineEnd,
    required bool isLineStartCompleted,
    required bool isLineEndCompleted,
    required ColorScheme colorScheme,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: hasLineStart
                  ? Container(
                      height: 2.5,
                      color: isLineStartCompleted
                          ? colorScheme.primary
                          : colorScheme.outlineVariant.withValues(alpha: 0.4),
                    )
                  : const SizedBox(),
            ),
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isCompleted
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: 15.0,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),
            Expanded(
              child: hasLineEnd
                  ? Container(
                      height: 2.5,
                      color: isLineEndCompleted
                          ? colorScheme.primary
                          : colorScheme.outlineVariant.withValues(alpha: 0.4),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          title,
          textAlign: TextAlign.center,
          style: isCompleted
              ? getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: colorScheme.primary,
                )
              : getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: colorScheme.onSurfaceVariant,
                ),
        ),
        if (time.isNotEmpty) ...[
          const SizedBox(height: Spacing.xxs),
          Text(
            time,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: colorScheme.onSurfaceVariant,
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
