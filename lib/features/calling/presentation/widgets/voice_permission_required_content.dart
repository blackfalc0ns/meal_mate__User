import 'package:flutter/material.dart';
import '../../../../config/theme/font_manager.dart';
import '../../../../config/theme/spacing.dart';
import '../../../../config/theme/styles_manager.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widget/app_button.dart';

class VoicePermissionRequiredContent extends StatelessWidget {
  const VoicePermissionRequiredContent({
    super.key,
    required this.onRequestPermission,
    required this.onOpenSettings,
    this.onDismiss,
    this.isPermanentlyDenied = false,
  });

  final VoidCallback onRequestPermission;
  final VoidCallback onOpenSettings;
  final VoidCallback? onDismiss;
  final bool isPermanentlyDenied;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      margin: const EdgeInsets.symmetric(horizontal: Spacing.base),
      decoration: BoxDecoration(
        color: color.errorContainer.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(
          color: color.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.mic_off_rounded,
                color: color.error,
                size: Spacing.iconMd,
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Text(
                  locale.calling_permission_required,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: isPermanentlyDenied
                      ? locale.calling_permission_settings
                      : locale.calling_permission_enable,
                  onPressed:
                      isPermanentlyDenied ? onOpenSettings : onRequestPermission,
                  height: Spacing.buttonSmallHeight - 4,
                  borderRadius: Spacing.buttonRadius,
                  color: color.error,
                  textColor: color.onError,
                  fontSize: FontSize.size12,
                ),
              ),
              if (onDismiss != null) ...[
                const SizedBox(width: Spacing.xs),
                TextButton(
                  onPressed: onDismiss,
                  child: Text(
                    locale.calling_permission_later,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
