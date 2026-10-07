import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';

Future<bool> requestFreezeConsent(BuildContext context, String notice) async {
  final accepted = await AppWoltModalSheet.show<bool>(
    context: context,
    title: context.localization.billing_freeze_confirm_title,
    child: SubscriptionFreezeNoticeSheet(notice: notice),
  );
  return accepted == true;
}

class SubscriptionFreezeNoticeSheet extends StatelessWidget {
  const SubscriptionFreezeNoticeSheet({
    required this.notice,
    super.key,
  });

  final String notice;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: color.surfaceContainerLow,
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(color: color.outlineVariant),
              ),
              constraints: const BoxConstraints(maxHeight: 280),
              child: SingleChildScrollView(
                child: Text(
                  notice,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            AppButton(
              text: locale.billing_freeze_consent_agree,
              onPressed: () => Navigator.of(context).pop(true),
              height: Spacing.buttonSmallHeight,
              borderRadius: Spacing.radiusPill,
              color: color.primary,
              textColor: color.onPrimary,
              fontSize: FontSize.size12,
            ),
            const SizedBox(height: Spacing.sm),
            AppButton.outlined(
              text: locale.billing_freeze_consent_cancel,
              onPressed: () => Navigator.of(context).pop(false),
              height: Spacing.buttonSmallHeight,
              borderRadius: Spacing.radiusPill,
              color: color.outline,
              textColor: color.onSurfaceVariant,
              fontSize: FontSize.size12,
            ),
          ],
        ),
      ),
    );
  }
}
