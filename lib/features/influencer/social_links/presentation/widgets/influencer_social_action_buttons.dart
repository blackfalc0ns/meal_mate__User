import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerSocialActionButtons extends StatelessWidget {
  const InfluencerSocialActionButtons({
    super.key,
    required this.onSave,
    required this.onSkip,
    this.isLoading = false,
  });

  final VoidCallback? onSave;
  final VoidCallback? onSkip;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: Spacing.influencerSocialSaveButtonHeight,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: color.primary,
              foregroundColor: color.onPrimary,
              elevation: Spacing.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Spacing.influencerSocialSaveButtonRadius,
                ),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: Spacing.iconMd,
                    height: Spacing.iconMd,
                    child: CircularProgressIndicator(
                      strokeWidth: Spacing.xxs,
                      color: color.onPrimary,
                    ),
                  )
                : Text(
                    locale.influencer_save_continue,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onPrimary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Center(
          child: GestureDetector(
            onTap: onSkip,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
              child: Text(
                locale.influencer_skip_now,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
