import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_package_card.dart';

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
            final contentWidth =
                constraints.maxWidth - Spacing.monthlyPlanPackageGap * 2;
            final designContentWidth =
                Spacing.monthlyPlanPackageSideWidth * 2 +
                Spacing.monthlyPlanPackageFeaturedWidth +
                Spacing.monthlyPlanPackageGap * 2;
            final scale = (contentWidth / designContentWidth)
                .clamp(0.0, 1.0)
                .toDouble();

            return Center(
              child: SizedBox(
                width: designContentWidth * scale,
                child: Row(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (
                      var index = 0;
                      index < widget.packages.length;
                      index++
                    ) ...[
                      MonthlyPlanPackageCard(
                        package: widget.packages[index],
                        width:
                            (widget.packages[index].isPopular
                                ? Spacing.monthlyPlanPackageFeaturedWidth
                                : Spacing.monthlyPlanPackageSideWidth) *
                            scale,
                        isSelected: _selectedIndex == index,
                        onTap: () => setState(() => _selectedIndex = index),
                        onBrowseRestaurants: widget.onBrowseRestaurants,
                      ),
                      if (index != widget.packages.length - 1)
                        SizedBox(width: Spacing.monthlyPlanPackageGap * scale),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
