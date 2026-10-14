import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/failed/payment_failed_info_box.dart';

/// Card container holding the payment failure headline, description, and info notice.
class PaymentFailedCard extends StatelessWidget {
  const PaymentFailedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locale.payment_failed_card_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size22,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.payment_failed_card_subtitle,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.base),
          const PaymentFailedInfoBox(),
        ],
      ),
    );
  }
}
