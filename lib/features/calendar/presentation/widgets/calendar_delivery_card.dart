import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_driver_row.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_header.dart';
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDeliveryHeader(deliveryItem: deliveryItem),
          const SizedBox(height: Spacing.md),
          CalendarDeliveryDriverRow(deliveryItem: deliveryItem),
          const SizedBox(height: Spacing.md),
          CalendarDeliveryTimeline(deliveryItem: deliveryItem),
          const SizedBox(height: Spacing.md),
          CalendarDeliveryTrackButton(
            deliveryItem: deliveryItem,
            onPressed: onTrackOrDetails,
          ),
        ],
      ),
    );
  }
}
