import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/features/meal_details/data/meal_details_fake_data_source.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_header_image.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_rating_badge.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_sheet.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  static const _dataSource = MealDetailsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final meal = _dataSource.getMeal();
    final textDirection = locale.localeName == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: color.surface,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                MealDetailsHeaderImage(label: meal.title),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          constraints.maxHeight -
                          (Spacing.xxxl * 3 + Spacing.xl),
                    ),
                    child: MealDetailsSheet(meal: meal),
                  ),
                ),
                Positioned(
                  left: Spacing.xl,
                  bottom: constraints.maxHeight - (Spacing.xxxl * 3),
                  child: MealDetailsRatingBadge(
                    title: meal.ratingTitle,
                    value: meal.ratingValue,
                  ),
                ),
                CustomBackButton(onPressed: () => Navigator.maybePop(context)),
              ],
            );
          },
        ),
      ),
    );
  }
}
