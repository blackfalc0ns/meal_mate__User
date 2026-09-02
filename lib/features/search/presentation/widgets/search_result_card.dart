import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/search/data/search_fake_data_source.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_result_meta.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.result});

  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isMeal = result == SearchResult.meal;
    final title = isMeal
        ? locale.search_meal_title
        : locale.search_restaurant_title;
    final description = isMeal
        ? locale.search_meal_description
        : locale.search_restaurant_description;
    final badge = isMeal
        ? locale.search_meal_badge
        : locale.search_restaurant_badge;

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = constraints.maxHeight * .52;
        final detailsTop = constraints.maxHeight * .4;

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            border: Border.all(color: color.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: .08),
                blurRadius: Spacing.xss,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: imageHeight,
                child: Image.asset(result.imageAsset, fit: BoxFit.cover),
              ),
              Positioned(
                top: detailsTop,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Spacing.radiusLg),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size13,
                                color: color.onSurface,
                              ),
                            ),
                          ),
                          if (!isMeal) ...[
                            const SizedBox(width: Spacing.xs),
                            Icon(
                              Icons.verified_rounded,
                              size: Spacing.iconSm,
                              color: color.primary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      if (isMeal)
                        Column(
                          children: [
                            Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SearchResultMeta(
                                  label: locale.search_calories,
                                  icon: Icons.local_fire_department_rounded,
                                  animationAsset: Assets.fireAnimation,
                                ),
                                SearchResultMeta(
                                  label: locale.search_carbs,
                                  icon: Icons.grain_rounded,
                                  animationAsset: Assets.wheatAnimation,
                                ),
                              ],
                            ),
                            const SizedBox(height: Spacing.xs),
                            Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SearchResultMeta(
                                  label: locale.search_protein,
                                  icon: Icons.fitness_center_rounded,
                                  animationAsset: Assets.muscleAnimation,
                                ),
                                SearchResultMeta(
                                  label: locale.search_fat,
                                  icon: Icons.water_drop_rounded,
                                  animationAsset: Assets.dropletAnimation,
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              locale.search_minutes,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: color.primary,
                              ),
                            ),
                            const SizedBox(width: Spacing.xs),
                            Icon(
                              Icons.schedule_rounded,
                              size: Spacing.iconSm,
                              color: color.primary,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: color.secondary,
                                borderRadius: BorderRadius.circular(
                                  Spacing.radiusXs,
                                ),
                              ),
                              child: Text(
                                locale.search_rating,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size9,
                                  color: color.onSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      const Spacer(),
                      const SizedBox(height: Spacing.xs),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: AppButton.filled(
                          text: isMeal
                              ? locale.search_show_details
                              : locale.search_show_restaurant,
                          onPressed: () {},
                          iconWidget: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: Spacing.iconSm - Spacing.xs,
                            color: color.primary,
                          ),
                          height: Spacing.xl,
                          borderRadius: Spacing.radiusSm,
                          color: color.primaryContainer,
                          textColor: color.primary,
                          fontSize: FontSize.size11,
                          fontWeight: FontWeightManger.bold,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xs,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: Spacing.xss,
                left: Spacing.xss,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.primary,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Text(
                    badge,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: color.onPrimary,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Spacing.xss,
                right: Spacing.xss,
                child: IconButton.filledTonal(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border_rounded,
                    color: color.primary,
                  ),
                  iconSize: Spacing.iconSm,
                  style: IconButton.styleFrom(
                    backgroundColor: color.surface,
                    minimumSize: const Size(Spacing.xxl, Spacing.xxl),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
