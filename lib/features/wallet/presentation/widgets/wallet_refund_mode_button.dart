import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletRefundModeButton extends StatelessWidget {
  const WalletRefundModeButton({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return Container(
      height: Spacing.walletToggleHeight,
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.primary,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Icon(icon, color: color.primary, size: Spacing.iconSm),
        ],
      ),
    );
  }
}
