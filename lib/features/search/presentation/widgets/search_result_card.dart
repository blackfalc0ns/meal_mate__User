import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(result.imageAsset, fit: BoxFit.cover),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(Spacing.xss),
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
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size7,
                        color: color.onPrimary,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xss),
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
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xss,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size11,
                            color: color.onSurface,
                          ),
                        ),
                      ),
                      if (!isMeal) ...[
                        const SizedBox(width: Spacing.xs),
                        Icon(
                          Icons.verified_rounded,
                          size: Spacing.iconSm - Spacing.xs,
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
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size9,
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
                            ),
                            SearchResultMeta(
                              label: locale.search_carbs,
                              icon: Icons.grain_rounded,
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
                            ),
                            SearchResultMeta(
                              label: locale.search_fat,
                              icon: Icons.water_drop_rounded,
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          locale.search_minutes,
                          style: getMediumStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size8,
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
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size8,
                              color: color.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Spacer(),
                  const SizedBox(height: Spacing.xss),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: SizedBox(
                      width: double.infinity,
                      height: Spacing.xl + Spacing.xs,
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                        label: Text(
                          isMeal
                              ? locale.search_show_details
                              : locale.search_show_restaurant,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: color.primaryContainer,
                          foregroundColor: color.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xs,
                          ),
                          textStyle: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size8,
                            color: color.primary,
                          ),
                        ),
                      ),
                    ),
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
