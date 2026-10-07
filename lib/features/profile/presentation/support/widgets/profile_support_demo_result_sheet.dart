import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';

class ProfileSupportDemoResultSheet extends StatelessWidget {
  const ProfileSupportDemoResultSheet({super.key, required this.onResetForm});

  final VoidCallback onResetForm;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onResetForm,
  }) {
    final locale = context.localization;

    return AppWoltModalSheet.show<void>(
      context: context,
      title: locale.profile_support_result_title,
      child: ProfileSupportDemoResultSheet(onResetForm: onResetForm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.cardPadding,
        vertical: Spacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Spacing.avatarMd,
            height: Spacing.avatarMd,
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: Spacing.iconLg,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            locale.profile_support_result_message,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  text: locale.profile_support_reset_button,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onResetForm();
                  },
                  height: Spacing.buttonSmallHeight,
                  color: color.outlineVariant,
                  textColor: color.onSurface,
                  fontSize: FontSize.size11,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: AppButton.filled(
                  text: locale.profile_support_result_confirm,
                  onPressed: () => Navigator.of(context).pop(),
                  height: Spacing.buttonSmallHeight,
                  color: color.primary,
                  textColor: color.onPrimary,
                  fontSize: FontSize.size11,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
        ],
      ),
    );
  }
}
