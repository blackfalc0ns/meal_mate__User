import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletFilterChip extends StatelessWidget {
  const WalletFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Spacing.walletFilterHeight,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color.primary : color.surface,
          borderRadius: BorderRadius.circular(Spacing.walletFilterRadius),
          border: Border.all(color: selected ? color.primary : color.outline),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: selected ? color.onPrimary : color.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
