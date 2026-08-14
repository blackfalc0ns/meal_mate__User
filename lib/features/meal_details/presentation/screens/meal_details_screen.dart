import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/features/meal_details/data/meal_details_fake_data_source.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_header_image.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_rating_badge.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_sheet.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, this.meal});

  static const _dataSource = MealDetailsFakeDataSource();

  final MealDetailsEntity? meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final details = meal ?? _dataSource.getMeal();
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
                MealDetailsHeaderImage(
                  label: details.title,
                  imageUrl: details.headerImageUrl,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          constraints.maxHeight -
                          (Spacing.xxxl * 3 + Spacing.xl),
                    ),
                    child: MealDetailsSheet(meal: details),
                  ),
                ),
                Positioned(
                  left: Spacing.xl,
                  bottom: constraints.maxHeight - (Spacing.xxxl * 3),
                  child: MealDetailsRatingBadge(
                    title: details.ratingTitle,
                    value: details.ratingValue,
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
