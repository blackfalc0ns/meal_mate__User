import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_package_card.dart';

class MonthlyPlanPackagesSection extends StatefulWidget {
  const MonthlyPlanPackagesSection({
    super.key,
    required this.packages,
    required this.onBrowseRestaurants,
  });

  final List<MonthlyPackageTierEntity> packages;
  final VoidCallback onBrowseRestaurants;

  @override
  State<MonthlyPlanPackagesSection> createState() =>
      _MonthlyPlanPackagesSectionState();
}

class _MonthlyPlanPackagesSectionState
    extends State<MonthlyPlanPackagesSection> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.calendar_browse_restaurants,
      child: ColoredBox(
        color: color.surface,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : Spacing.monthlyPlanPackagesWidth;
            final cardWidth = width < Spacing.monthlyPlanPackagesWidth
                ? width
                : Spacing.monthlyPlanPackagesWidth;
            final selectedIndex = _selectedIndex ?? 0;

            return Center(
              child: SizedBox(
                width: cardWidth,
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: SizedBox(
                        width: Spacing.monthlyPlanPackagesHeaderWidth,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.grid_view_rounded,
                              size: Spacing.iconLg,
                              color: color.primary,
                            ),
                            const SizedBox(width: Spacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locale
                                        .subscription_restaurant_categories_title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size18,
                                      color: color.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: Spacing.xs),
                                  Text(
                                    locale
                                        .subscription_restaurant_categories_subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: getMediumStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size12,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    for (var index = 0; index < widget.packages.length; index++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: index == widget.packages.length - 1
                              ? Spacing.zero
                              : Spacing.monthlyPlanPackageGap,
                        ),
                        child: MonthlyPlanPackageCard(
                          package: widget.packages[index],
                          title: _packageTitle(locale, index),
                          width: cardWidth,
                          height: Spacing.monthlyPlanPackageSideHeight,
                          isCentered: index == 1,
                          isSelected: selectedIndex == index,
                          onTap: () => setState(() => _selectedIndex = index),
                          onBrowseRestaurants: widget.onBrowseRestaurants,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _packageTitle(dynamic locale, int index) {
    return switch (index) {
      0 => locale.subscription_tier_elite,
      1 => locale.subscription_tier_plus,
      _ => locale.subscription_tier_max,
    };
  }
}
