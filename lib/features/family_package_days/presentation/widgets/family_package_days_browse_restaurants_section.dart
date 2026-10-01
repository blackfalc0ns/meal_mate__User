import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurants_grid.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_browse_restaurants_loading_skeleton.dart';

class FamilyPackageDaysBrowseRestaurantsSection extends StatelessWidget {
  const FamilyPackageDaysBrowseRestaurantsSection({
    super.key,
    required this.state,
    this.programId,
  });

  final FamilyPlanState state;
  final String? programId;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final member = state.selectedMember;
    final resolvedProgramId =
        programId ??
        state.selectedProgram?.programId ??
        member?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : '');

    var bundle = state.selectedBundle;
    if (bundle == null && member?.bundleId != null) {
      for (final item in state.bundles) {
        if (item.bundleId == member!.bundleId) {
          bundle = item;
          break;
        }
      }
    }
    bundle ??= state.bundles.isNotEmpty ? state.bundles.first : null;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.calendar_browse_restaurants,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context
                  .read<FamilyPackageDaysViewModel>()
                  .doIntent(const CloseFamilyBrowseRestaurantsEvent()),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        if (state.isBrowseRestaurantsLoading)
          const FamilyBrowseRestaurantsLoadingSkeleton()
        else if (state.browseRestaurants.isEmpty)
          EmptyStateWidget(
            title: locale.family_packages_empty,
            description: '',
            icon: Icons.storefront_rounded,
          )
        else
          SubscriptionRestaurantsGrid(
            crossAxisCount: 3,
            childAspectRatio: 0.76,
            restaurants: state.browseRestaurants.map((restaurant) {
              return restaurant.toRestaurantPlan(
                programId: resolvedProgramId,
                bundleId: bundle?.bundleId ?? '',
                localeName: locale.localeName,
                brandColor: color.primary,
              );
            }).toList(),
          ),
        const SizedBox(height: Spacing.lg),
      ],
    );
  }
}
