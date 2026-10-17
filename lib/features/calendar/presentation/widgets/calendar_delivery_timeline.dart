import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_timeline_connector.dart';

class CalendarDeliveryTimeline extends StatelessWidget {
  const CalendarDeliveryTimeline({super.key, required this.deliveryItem});

  final CustomerDeliveryItemEntity deliveryItem;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isDelivered = deliveryItem.isDelivered;
    final isOut =
        deliveryItem.isOutForDelivery ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.arrived ||
        isDelivered;
    final isPrepared =
        isOut ||
        deliveryItem.deliveryStatus == CustomerDeliveryStatus.ready ||
        deliveryItem.hasReady;

    final preparedTime = _formatTime(
      deliveryItem.readyAtUtc,
      locale.localeName,
      '',
    );
    final outTime = _formatTime(
      deliveryItem.pickedUpAtUtc,
      locale.localeName,
      '',
    );

    final lineColor = color.onPrimary.withValues(alpha: 0.6);
    final inactiveLineColor = color.onPrimary.withValues(alpha: 0.3);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step 1: تم التجهيز
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                child: Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPrepared
                            ? color.onPrimary
                            : color.onPrimary.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPrepared
                                ? color.primary
                                : color.onPrimary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CalendarDeliveryTimelineConnector(
                        isDashed: true,
                        color: isOut ? lineColor : inactiveLineColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                locale.calendar_delivery_step_prepared,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onPrimary,
                ),
              ),
              if (preparedTime.isNotEmpty) ...[
                const SizedBox(height: Spacing.xs),
                Text(
                  preparedTime,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Step 2: خرج للتوصيل
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: CalendarDeliveryTimelineConnector(
                        isDashed: true,
                        color: isOut ? lineColor : inactiveLineColor,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOut
                            ? color.onPrimary
                            : color.onPrimary.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.local_shipping_rounded,
                        color: isOut
                            ? color.primary
                            : color.onPrimary.withValues(alpha: 0.6),
                        size: Spacing.iconXs,
                      ),
                    ),
                    Expanded(
                      child: CalendarDeliveryTimelineConnector(
                        isDashed: false,
                        color: isDelivered ? lineColor : inactiveLineColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                locale.calendar_delivery_step_out,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onPrimary,
                ),
              ),
              if (outTime.isNotEmpty) ...[
                const SizedBox(height: Spacing.xxs),
                Text(
                  outTime,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size8,
                    color: color.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Step 3: تم التسليم
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: CalendarDeliveryTimelineConnector(
                        isDashed: false,
                        color: isDelivered ? lineColor : inactiveLineColor,
                      ),
                    ),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDelivered ? color.onPrimary : null,
                        border: Border.all(
                          color: isDelivered
                              ? color.onPrimary
                              : color.onPrimary.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: isDelivered
                          ? Icon(
                              Icons.check_rounded,
                              size: Spacing.iconXs,
                              color: color.primary,
                            )
                          : null,
                    ),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                locale.calendar_delivery_step_delivered,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onPrimary.withValues(
                    alpha: isDelivered ? 1.0 : 0.75,
                  ),
                ),
              ),
              if (isDelivered && deliveryItem.deliveredAtUtc != null) ...[
                const SizedBox(height: Spacing.xxs),
                Text(
                  _formatTime(
                    deliveryItem.deliveredAtUtc,
                    locale.localeName,
                    '',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime? date, String localeCode, String fallback) {
    if (date == null) return fallback;
    try {
      return DateFormat('h:mm a', localeCode).format(date.toLocal());
    } catch (_) {
      return fallback;
    }
  }
}
