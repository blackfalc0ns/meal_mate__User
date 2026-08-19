import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class BiometricPromptSheet extends StatefulWidget {
  const BiometricPromptSheet({
    super.key,
    required this.biometricType,
    required this.onComplete,
  });

  final BiometricTypeEnum biometricType;
  final VoidCallback onComplete;

  static Future<void> showIfNeeded(
    BuildContext context, {
    required VoidCallback onComplete,
  }) async {
    final biometricService = getIt<BiometricService>();
    final isSupported = await biometricService.isDeviceSupported();
    final isEnabled = biometricService.isBiometricEnabled();

    if (!isSupported || isEnabled) {
      onComplete();
      return;
    }

    if (!context.mounted) {
      onComplete();
      return;
    }

    final biometricType = await biometricService.getPrimaryBiometricType();

    if (!context.mounted) {
      onComplete();
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (_) => BiometricPromptSheet(
        biometricType: biometricType,
        onComplete: onComplete,
      ),
    );
  }

  @override
  State<BiometricPromptSheet> createState() => _BiometricPromptSheetState();
}

class _BiometricPromptSheetState extends State<BiometricPromptSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isFace = widget.biometricType == BiometricTypeEnum.face;
    final iconData =
        isFace ? Icons.face_rounded : Icons.fingerprint_rounded;
    final biometricName = isFace
        ? locale.biometric_face_id
        : locale.biometric_fingerprint;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xl,
        vertical: Spacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: 40,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            locale.biometric_prompt_enable_dialog_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.biometric_prompt_enable_dialog_body,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.xl),
          AppButton.filled(
            text: '${locale.biometric_enable_button} ($biometricName)',
            isLoading: _isLoading,
            onPressed: _handleEnable,
            color: color.primary,
            textColor: color.onPrimary,
          ),
          const SizedBox(height: Spacing.sm),
          AppButton.text(
            text: locale.biometric_skip_button,
            onPressed: () {
              Navigator.of(context).pop();
              widget.onComplete();
            },
            textColor: color.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Future<void> _handleEnable() async {
    setState(() {
      _isLoading = true;
    });

    final locale = context.localization;
    final biometricService = getIt<BiometricService>();

    final result = await biometricService.authenticate(
      localizedReason: locale.biometric_enable_reason,
    );

    if (result.isSuccess) {
      await biometricService.setBiometricEnabled(true);
    }

    if (mounted) {
      Navigator.of(context).pop();
      widget.onComplete();
    }
  }
}
