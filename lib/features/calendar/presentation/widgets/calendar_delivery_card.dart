import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_delivered_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_driver_row.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_header.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_info_row.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_timeline.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_track_button.dart';

class CalendarDeliveryCard extends StatelessWidget {
  const CalendarDeliveryCard({
    super.key,
    required this.deliveryItem,
    required this.onTrackOrDetails,
  });

  final CustomerDeliveryItemEntity deliveryItem;
  final VoidCallback onTrackOrDetails;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    if (deliveryItem.isDelivered) {
      return CalendarDeliveryDeliveredCard(
        deliveryItem: deliveryItem,
        onDetails: onTrackOrDetails,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDeliveryHeader(deliveryItem: deliveryItem),
          const SizedBox(height: Spacing.sm),
          CalendarDeliveryDriverRow(deliveryItem: deliveryItem),
          const SizedBox(height: Spacing.sm),
          CalendarDeliveryTimeline(deliveryItem: deliveryItem),
          const SizedBox(height: Spacing.sm),
          CalendarDeliveryInfoRow(
            deliveryItem: deliveryItem,
            isDarkVariant: true,
          ),
          const SizedBox(height: Spacing.sm),
          CalendarDeliveryTrackButton(
            deliveryItem: deliveryItem,
            onPressed: onTrackOrDetails,
          ),
        ],
      ),
    );
  }
}
