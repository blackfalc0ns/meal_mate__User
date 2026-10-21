import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_data.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_icon.dart';

class OfferDetailsInfoRow extends StatelessWidget {
  const OfferDetailsInfoRow({super.key, required this.row});

  final OfferDetailsInfoRowData row;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final emphasizedValue = row.emphasizedValue;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: Spacing.offerDetailsInfoRowHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.primaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(Spacing.lg),
              ),
              child: SizedBox.square(
                dimension: Spacing.offerDetailsInfoIconBox,
                child: Center(
                  child: OfferDetailsIcon(
                    type: row.icon,
                    size: Spacing.offerDetailsInfoIconSize,
                    tint: color.tertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Spacing.base),
            Text(
              row.label,
              semanticsLabel: locale.app_brand_name,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: emphasizedValue == null
                    ? Text(
                        row.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onSurfaceVariant,
                        ),
                      )
                    : Text.rich(
                        TextSpan(
                          text: row.value.replaceFirst(emphasizedValue, ''),
                          children: [
                            TextSpan(
                              text: emphasizedValue,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size12,
                                color: color.tertiary,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
