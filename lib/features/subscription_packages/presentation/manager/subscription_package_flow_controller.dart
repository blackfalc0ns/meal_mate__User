import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_prerequisite_bottom_sheet.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_event.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_state.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_view_model.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionPackageFlowController {
  SubscriptionPackageFlowController({
    required this.selectedProgram,
    required this.viewModel,
  });

  final SubscriptionProgramEntity? selectedProgram;
  final SubscriptionPackagesViewModel viewModel;

  final ValueNotifier<int?> selectedPackageNotifier = ValueNotifier<int?>(null);
  bool _continueAfterProfileUpdate = false;

  void selectPackage(int index) {
    if (selectedPackageNotifier.value == index) return;
    selectedPackageNotifier.value = index;
  }

  bool shouldListenToProfileUpdate(
    SubscriptionPackagesState previous,
    SubscriptionPackagesState current,
  ) {
    return _continueAfterProfileUpdate &&
        previous.isLoading &&
        !current.isLoading;
  }

  Future<void> handleProfileUpdatedListener(
    BuildContext context,
    SubscriptionPackagesState state,
  ) async {
    _continueAfterProfileUpdate = false;
    if (state.failure == null) {
      await continueWithProfileStatus(context, state);
    }
  }

  Future<void> continueWithProfileStatus(
    BuildContext context,
    SubscriptionPackagesState state,
  ) async {
    final destinations =
        SubscriptionPrerequisiteDestination.listFromProfileStatus(
          hasDeliveryAddress: state.hasDeliveryAddress,
          hasAllergies: state.hasAllergies,
          hasDietaryPreferences: state.hasDietaryPreferences,
        );

    if (destinations.isNotEmpty) {
      await _showPrerequisiteSheet(context, destinations);
      return;
    }

    await openSelectedPackage(context, state.bundles);
  }

  Future<void> openSelectedPackage(
    BuildContext context,
    List<SubscriptionBundleEntity> bundles,
  ) async {
    final selectedIndex = selectedPackageNotifier.value;
    if (selectedIndex == null || selectedProgram == null) return;
    if (selectedIndex >= bundles.length) return;

    await context.pushNamed(
      AppRoutes.subscriptionPlanDetails,
      arguments: SubscriptionPlanDetailsArgs(
        program: selectedProgram!,
        bundle: bundles[selectedIndex],
      ),
    );
  }

  Future<void> _showPrerequisiteSheet(
    BuildContext context,
    List<SubscriptionPrerequisiteDestination> destinations,
  ) {
    return context.showAppBottomSheet<void>(
      builder: (sheetContext) => SubscriptionPrerequisiteBottomSheet(
        destinations: destinations,
        onDestinationSelected: (destination) async {
          Navigator.of(sheetContext).pop();
          final updated = await Navigator.of(context).pushNamed(
            _routeForPrerequisite(destination),
            arguments: const SubscriptionFlowArgs(),
          );
          if (updated == true && context.mounted) {
            if (selectedProgram == null) return;
            _continueAfterProfileUpdate = true;
            viewModel.doIntent(
              GetSubscriptionPackagesEvent(selectedProgram!.programId),
            );
          }
        },
      ),
    );
  }

  String _routeForPrerequisite(
    SubscriptionPrerequisiteDestination destination,
  ) {
    return switch (destination) {
      SubscriptionPrerequisiteDestination.address =>
        AppRoutes.addressChooseLocation,
      SubscriptionPrerequisiteDestination.allergies => AppRoutes.addAllergy,
      SubscriptionPrerequisiteDestination.dietaryPreferences =>
        AppRoutes.dietaryPreferences,
    };
  }

  void dispose() {
    selectedPackageNotifier.dispose();
  }
}
