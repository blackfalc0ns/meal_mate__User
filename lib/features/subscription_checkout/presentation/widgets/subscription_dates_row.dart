import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_date_card.dart';

class SubscriptionDatesRow extends StatelessWidget {
  const SubscriptionDatesRow({
    super.key,
    required this.paymentDate,
    required this.startDate,
    required this.endDate,
    required this.onEditStartDate,
  });

  final String paymentDate;
  final String startDate;
  final String endDate;
  final VoidCallback onEditStartDate;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Row(
      children: [
        Expanded(
          child: SubscriptionDateCard(
            label: locale.subscription_payment_date,
            date: paymentDate,
          ),
        ),
        const SizedBox(width: Spacing.xss),
        Expanded(
          child: SubscriptionDateCard(
            label: locale.subscription_start_date,
            date: startDate,
            isEditable: true,
            onTap: onEditStartDate,
          ),
        ),
        const SizedBox(width: Spacing.xss),
        Expanded(
          child: SubscriptionDateCard(
            label: locale.subscription_end_date,
            date: endDate,
          ),
        ),
      ],
    );
  }
}
