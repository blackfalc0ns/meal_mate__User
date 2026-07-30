import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_icon.dart';

class OfferDetailsInfoRow extends StatelessWidget {
  const OfferDetailsInfoRow({super.key, required this.row});

  final OfferDetailsInfoRowData row;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final emphasizedValue = row.emphasizedValue;

    return SizedBox(
      height: Spacing.offerDetailsInfoRowHeight,
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
          const Spacer(),
          SizedBox(
            width: Spacing.offerDetailsInfoValueWidth,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: emphasizedValue == null
                  ? Text(
                      row.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    
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
                      maxLines: 1,
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
    );
  }
}
