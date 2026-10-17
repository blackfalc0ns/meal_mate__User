import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_delivered_header.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_info_row.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_proof_card.dart';

class CalendarDeliveryDeliveredCard extends StatelessWidget {
  const CalendarDeliveryDeliveredCard({
    super.key,
    required this.deliveryItem,
    required this.onDetails,
  });

  final CustomerDeliveryItemEntity deliveryItem;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.6),
          width: Spacing.border,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDeliveryDeliveredHeader(deliveryItem: deliveryItem),
          const SizedBox(height: Spacing.md),
          CalendarDeliveryProofCard(
            deliveryItem: deliveryItem,
            onViewPhoto: onDetails,
          ),
          const SizedBox(height: Spacing.md),
          CalendarDeliveryInfoRow(
            deliveryItem: deliveryItem,
            isDarkVariant: false,
          ),
        ],
      ),
    );
  }
}
