import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletActionButton extends StatelessWidget {
  const WalletActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);
    final foreground = filled ? color.onPrimary : color.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.walletActionRadius),
      child: Container(
        height: Spacing.walletActionHeight,
        decoration: BoxDecoration(
          color: filled ? color.primary : color.surface,
          borderRadius: BorderRadius.circular(Spacing.walletActionRadius),
          border: Border.all(color: color.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground, size: Spacing.iconLg),
            const SizedBox(width: Spacing.sm),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
