import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';

class MealDetailsMacroItem extends StatelessWidget {
  const MealDetailsMacroItem({super.key, required this.item});

  final MealDetailsMacroEntity item;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: Spacing.avatarMd,
            height: Spacing.avatarMd,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.surface,
              border: Border.all(color: color.outlineVariant),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            child: Text(
              item.percent,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ).copyWith(height: 1),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size8,
              color: color.onSurface,
            ).copyWith(height: locale.localeName == 'ar' ? 1.4 : 1.15),
          ),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size8,
              color: color.onSurface,
            ).copyWith(height: locale.localeName == 'ar' ? 1.4 : 1.15),
          ),
        ],
      ),
    );
  }
}
