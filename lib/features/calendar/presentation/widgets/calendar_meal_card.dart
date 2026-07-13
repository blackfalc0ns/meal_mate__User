import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';

class CalendarMealCard extends StatelessWidget {
  const CalendarMealCard({super.key, required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 147,
      child: Column(
        children: [
          SizedBox(
            height: 114,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.brandDeepGreen),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.10),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      meal.imageAsset,
                      width: 83,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: _MealDetails(meal: meal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 25,
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openMealPicker(context),
              icon: const Icon(Icons.edit_rounded, size: 13),
              label: Text(meal.actionLabel),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandDeepGreen,
                foregroundColor: color.onPrimary,
                padding: EdgeInsets.zero,
                textStyle: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 9.3,
                  color: color.onPrimary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openMealPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black,
      builder: (_) => const CalendarMealPickerSheet(),
    );
  }
}

class _MealDetails extends StatelessWidget {
  const _MealDetails({required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: _MealTypeBadge(mealType: meal.mealType),
        ),
        const SizedBox(height: 1),
        Text(
          meal.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: 14.5,
            color: color.onSurface,
          ).copyWith(height: 1.15),
        ),
        const SizedBox(height: 6),
        _NutritionRow(meal: meal),
        const Spacer(),
        Text(
          'المكونات',
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: 6.8,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (final ingredient in meal.ingredients) ...[
              _IngredientChip(label: ingredient),
              const SizedBox(width: 4.3),
            ],
          ],
        ),
      ],
    );
  }
}

class _MealTypeBadge extends StatelessWidget {
  const _MealTypeBadge({required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,

      children: [
        Text(
          mealType,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: 7.55,
            color: AppColors.secondary500,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(
          Icons.wb_sunny_rounded,
          color: AppColors.brandDeepGreen,
          size: 13,
        ),
      ],
    );
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final items = [
      _NutritionItem(
        icon: Icons.local_fire_department_rounded,
        value: meal.calories,
        label: 'سعرة حرارية',
      ),
      _NutritionItem(
        icon: Icons.fitness_center_rounded,
        value: meal.protein,
        label: 'بروتين',
      ),
      _NutritionItem(
        icon: Icons.rice_bowl_rounded,
        value: meal.carbs,
        label: 'كربوهيدرات',
      ),
      _NutritionItem(
        icon: Icons.water_drop_rounded,
        value: meal.fat,
        label: 'دهون',
      ),
    ];

    return SizedBox(
      height: 22,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            items[index],
            if (index != items.length - 1)
              Container(
                width: 0.5,
                height: 20,
                color: color.onSurface.withValues(alpha: 0.20),
              ),
          ],
        ],
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  const _NutritionItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: label == 'سعرة حرارية' ? 48 : 34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 10.5, color: AppColors.brandDeepGreen),
              const SizedBox(width: 1.5),
              FittedBox(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size7,
                    color: color.onSurface,
                  ).copyWith(height: 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 6.1,
              color: color.onSurface.withValues(alpha: 0.62),
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isMore = label.contains('المزيد');

    return Container(
      height: 14.75,
      constraints: BoxConstraints(
        minWidth: isMore ? 28.6 : 30,
        maxWidth: isMore ? 42 : 58,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(7.4),
        border: Border.all(color: AppColors.brandDeepGreen, width: 0.45),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isMore) ...[
            Icon(
              _ingredientIcon(label),
              size: 8.7,
              color: AppColors.brandDeepGreen,
            ),
            const SizedBox(width: 2),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: 5.2,
                color: isMore
                    ? AppColors.calendarTextPrimary
                    : color.onSurface.withValues(alpha: 0.62),
              ).copyWith(height: 1),
            ),
          ),
        ],
      ),
    );
  }

  IconData _ingredientIcon(String label) {
    if (label.contains('جزر')) return Icons.eco_rounded;
    if (label.contains('بروكلي')) return Icons.spa_rounded;
    return Icons.rice_bowl_rounded;
  }
}
