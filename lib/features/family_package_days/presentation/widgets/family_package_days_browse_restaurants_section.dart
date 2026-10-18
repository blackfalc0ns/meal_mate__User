import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
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

  final FamilyPackageDaysState state;
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
        else if (state.browseRestaurantsFailure != null)
          _buildRestaurantsError(context, state.browseRestaurantsFailure!)
        else if (state.browseRestaurants.isEmpty)
          EmptyStateWidget(
            title: locale.family_browse_restaurants_empty,
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

  Widget _buildRestaurantsError(BuildContext context, Failure failure) {
    final color = context.colorScheme;
    final locale = context.localization;
    final errorMsg = failure.errorMessage;
    final isAddressRequired = errorMsg.contains('family.address_required') ||
        errorMsg.contains('ADDRESS') ||
        errorMsg.contains('address_required');

    if (isAddressRequired) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: Spacing.sm),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: color.errorContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          border: Border.all(
            color: color.error.withValues(alpha: 0.3),
            width: Spacing.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_off_rounded,
              color: color.error,
              size: Spacing.iconXl,
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              locale.family_address_required_error,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            OutlinedButton.icon(
              onPressed: () {
                unawaited(
                  Navigator.of(context).pushNamed(AppRoutes.familyAddresses),
                );
              },
              icon: const Icon(Icons.location_on_rounded, size: Spacing.iconSm),
              label: Text(locale.family_go_to_addresses),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: color.error,
            size: Spacing.iconXl,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            ErrorMessagePresenter.fromFailure(context, failure),
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
