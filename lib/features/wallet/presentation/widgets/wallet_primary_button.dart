import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletPrimaryButton extends StatelessWidget {
  const WalletPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return SizedBox(
      height: Spacing.walletLargeButtonHeight,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: filled ? color.primary : color.surface,
          foregroundColor: filled ? color.onPrimary : color.primary,
          side: BorderSide(color: color.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
          ),
        ),
        child: Text(
          label,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size20,
            color: filled ? color.onPrimary : color.primary,
          ),
        ),
      ),
    );
  }
}
