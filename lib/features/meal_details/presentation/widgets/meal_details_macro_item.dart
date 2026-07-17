import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
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
    final progressColor = item.type == MealDetailsNutritionType.protein
        ? color.secondary
        : color.primary;

    return Expanded(
      child: Column(
        children: [
          SizedBox(
            width: Spacing.avatarMd,
            height: Spacing.avatarMd,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _progress),
              duration: AppDurations.slower,
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: Spacing.xs,
                        backgroundColor: color.outlineVariant,
                        color: progressColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '%${(value * 100).round()}',
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size12,
                        color: color.onSurface,
                      ).copyWith(height: 1),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size10,
              color: color.onSurface,
            ).copyWith(height: locale.localeName == 'ar' ? 1.4 : 1.15),
          ),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size9,
              color: color.onSurface,
            ).copyWith(height: locale.localeName == 'ar' ? 1.4 : 1.15),
          ),
        ],
      ),
    );
  }

  double get _progress {
    final value = item.percent.replaceAll(RegExp('[^0-9]'), '');
    return (double.tryParse(value) ?? 0) / 100;
  }
}
