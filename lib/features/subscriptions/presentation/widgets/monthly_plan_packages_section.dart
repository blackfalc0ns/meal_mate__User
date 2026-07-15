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
  int _selectedIndex = 1;

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
            final cardWidth =
                (constraints.maxWidth - (Spacing.sm * 2)) /
                widget.packages.length;

            return Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (
                  var index = 0;
                  index < widget.packages.length;
                  index++
                ) ...[
                  Expanded(
                    child: MonthlyPlanPackageCard(
                      package: widget.packages[index],
                      width: cardWidth,
                      isSelected: _selectedIndex == index,
                      onTap: () => setState(() => _selectedIndex = index),
                      onBrowseRestaurants: widget.onBrowseRestaurants,
                    ),
                  ),
                  if (index != widget.packages.length - 1)
                    const SizedBox(width: Spacing.sm),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
