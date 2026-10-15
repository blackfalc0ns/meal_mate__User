import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class CampaignPendingStatusView extends StatelessWidget {
  const CampaignPendingStatusView({
    super.key,
    required this.onCheckStatus,
    this.pollCount = 0,
  });

  final VoidCallback onCheckStatus;
  final int pollCount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                color: color.primary,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Text(
              locale.campaign_payment_verifying,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              locale.campaign_payment_pending,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xl),
            AppButton(
              text: locale.payment_check_status_button,
              onPressed: onCheckStatus,
              height: Spacing.xl * 1.5,
              borderRadius: Spacing.sm,
            ),
          ],
        ),
      ),
    );
  }
}
