import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletSearchFilterRow extends StatelessWidget {
  const WalletSearchFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: Spacing.walletSearchHeight,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
            decoration: BoxDecoration(
              color: color.surface,
              border: Border.all(color: color.outline),
              borderRadius: BorderRadius.circular(Spacing.walletActionRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    locale.wallet_search_hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onSurfaceVariant.withValues(alpha: 0.45),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Icon(Icons.search_rounded, color: color.onSurfaceVariant),
              ],
            ),
          ),
        ),
        const SizedBox(width: Spacing.md),

        Container(
          height: Spacing.walletSearchHeight,
          width: Spacing.walletSearchHeight + Spacing.sm,
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outline),
            borderRadius: BorderRadius.circular(Spacing.walletActionRadius),
          ),
          child: Icon(Icons.tune_rounded, color: color.primary),
        ),
      ],
    );
  }
}
