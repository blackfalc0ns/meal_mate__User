import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletInfoCard extends StatelessWidget {
  const WalletInfoCard({
    super.key,
    required this.title,
    required this.body,
    this.height = Spacing.walletPaymentCardHeight,
  });

  final String title;
  final String body;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return Container(
      constraints: BoxConstraints(minHeight: height),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: color.tertiaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(Spacing.walletInfoRadius),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.primaryContainer.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: Spacing.walletTransactionIconBox,
              child: Icon(
                Icons.info_rounded,
                color: color.primary,
                size: Spacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: Spacing.base),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty) ...[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                  ],
                  Text(
                    body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ).copyWith(height: 1.45),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
