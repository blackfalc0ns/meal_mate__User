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
            final scale =
                (constraints.maxWidth / Spacing.monthlyPlanPackagesWidth)
                    .clamp(0.0, 1.0)
                    .toDouble();
            final initialSelectedIndex = widget.packages.indexWhere(
              (package) => package.isPopular,
            );
            final selectedIndex =
                _selectedIndex ??
                (initialSelectedIndex == -1 ? 0 : initialSelectedIndex);
            final sideIndexes = [
              for (var index = 0; index < widget.packages.length; index++)
                if (index != selectedIndex) index,
            ];
            final slotIndexes = [
              sideIndexes.first,
              selectedIndex,
              sideIndexes.last,
            ];

            return Center(
              child: SizedBox(
                width: Spacing.monthlyPlanPackagesWidth * scale,
                height: Spacing.monthlyPlanPackageHeight * scale,
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: Spacing.monthlyPlanPackagesWidth,
                    height: Spacing.monthlyPlanPackageHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (var slot = 0; slot < slotIndexes.length; slot++)
                          AnimatedPositioned(
                            key: ValueKey(widget.packages[slotIndexes[slot]]),
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeInOutCubic,
                            left: slot == 0
                                ? Spacing.monthlyPlanPackageBasicLeft
                                : slot == 1
                                ? Spacing.monthlyPlanPackageFeaturedLeft
                                : Spacing.monthlyPlanPackagePremiumLeft,
                            top: slot == 1
                                ? Spacing.monthlyPlanPackageFeaturedTop
                                : Spacing.monthlyPlanPackageSideTop,
                            width: slot == 1
                                ? Spacing.monthlyPlanPackageFeaturedWidth
                                : Spacing.monthlyPlanPackageSideWidth,
                            height: slot == 1
                                ? Spacing.monthlyPlanPackageFeaturedHeight
                                : Spacing.monthlyPlanPackageSideHeight,
                            child: MonthlyPlanPackageCard(
                              package: widget.packages[slotIndexes[slot]],
                              width: slot == 1
                                  ? Spacing.monthlyPlanPackageFeaturedWidth
                                  : Spacing.monthlyPlanPackageSideWidth,
                              height: slot == 1
                                  ? Spacing.monthlyPlanPackageFeaturedHeight
                                  : Spacing.monthlyPlanPackageSideHeight,
                              isCentered: slot == 1,
                              isSelected: selectedIndex == slotIndexes[slot],
                              onTap: () => setState(
                                () => _selectedIndex = slotIndexes[slot],
                              ),
                              onBrowseRestaurants: widget.onBrowseRestaurants,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
