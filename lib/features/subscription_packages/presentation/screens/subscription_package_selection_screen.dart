import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_prerequisite_bottom_sheet.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_event.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_state.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_view_model.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_package_selection_view.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_packages_bottom_bar.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_packages_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class SubscriptionPackageSelectionScreen extends StatefulWidget {
  const SubscriptionPackageSelectionScreen({super.key, this.selectedProgram});

  final SubscriptionProgramEntity? selectedProgram;

  @override
  State<SubscriptionPackageSelectionScreen> createState() =>
      _SubscriptionPackageSelectionScreenState();
}

class _SubscriptionPackageSelectionScreenState
    extends State<SubscriptionPackageSelectionScreen> {
  final ValueNotifier<int?> _selectedPackageNotifier =
      ValueNotifier<int?>(null);
  bool _continueAfterProfileUpdate = false;

  @override
  void dispose() {
    _selectedPackageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final selectedProgram = widget.selectedProgram;

    return BlocProvider<SubscriptionPackagesViewModel>(
      create: (_) {
        final viewModel = getIt<SubscriptionPackagesViewModel>();
        if (selectedProgram != null) {
          viewModel.doIntent(
            GetSubscriptionPackagesEvent(selectedProgram.programId),
          );
        }
        return viewModel;
      },
      child: BlocListener<
        SubscriptionPackagesViewModel,
        SubscriptionPackagesState
      >(
        listenWhen: (previous, current) =>
            _continueAfterProfileUpdate &&
            previous.isLoading &&
            !current.isLoading,
        listener: (context, state) async {
          _continueAfterProfileUpdate = false;
          if (state.failure == null) {
            await _continueWithProfileStatus(context, state);
          }
        },
        child: Scaffold(
          backgroundColor: color.surface,
          appBar: CustomAppBar(
            titleWidget: const AppLogo(
              alignment: CrossAxisAlignment.center,
            ),
            backgroundColor: color.surface,
            onBackPressed: () => Navigator.maybePop(context),
          ),
          bottomNavigationBar: BlocSelector<
            SubscriptionPackagesViewModel,
            SubscriptionPackagesState,
            ({bool hasBundles, bool isLoading})
          >(
            selector: (state) => (
              hasBundles: state.bundles.isNotEmpty,
              isLoading: state.isLoading,
            ),
            builder: (context, data) {
              return SubscriptionPackagesBottomBar(
                selectedPackageNotifier: _selectedPackageNotifier,
                hasBundles: data.hasBundles,
                isLoading: data.isLoading,
                onContinue: () {
                  final state =
                      context.read<SubscriptionPackagesViewModel>().state;
                  unawaited(_continueWithProfileStatus(context, state));
                },
              );
            },
          ),
          body: BlocBuilder<
            SubscriptionPackagesViewModel,
            SubscriptionPackagesState
          >(
            buildWhen: (previous, current) =>
                previous.isLoading != current.isLoading ||
                previous.isSuccess != current.isSuccess ||
                previous.failure != current.failure ||
                previous.bundles != current.bundles,
            builder: (context, state) {
              return _buildBody(context, state, selectedProgram);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SubscriptionPackagesState state,
    SubscriptionProgramEntity? selectedProgram,
  ) {
    final locale = context.localization;

    if (selectedProgram == null) {
      return EmptyStateWidget(
        title: locale.subscription_program_title,
        description: locale.subscription_program_subtitle,
        icon: Icons.restaurant_menu_rounded,
      );
    }

    if (state.isLoading && state.bundles.isEmpty) {
      return const SubscriptionPackagesLoadingSkeleton();
    }

    if (state.failure != null && state.bundles.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => context.read<SubscriptionPackagesViewModel>().doIntent(
          GetSubscriptionPackagesEvent(selectedProgram.programId),
        ),
      );
    }

    if (state.isSuccess && state.bundles.isEmpty) {
      return EmptyStateWidget(
        title: locale.subscription_packages_empty_title,
        description: locale.subscription_packages_empty_description,
        icon: Icons.restaurant_menu_rounded,
      );
    }

    return SubscriptionPackageSelectionView(
      selectedProgram: selectedProgram,
      bundles: state.bundles,
      selectedPackageNotifier: _selectedPackageNotifier,
      onPackageSelected: _selectPackage,
    );
  }

  void _selectPackage(int index) {
    if (_selectedPackageNotifier.value == index) return;
    _selectedPackageNotifier.value = index;
  }

  Future<void> _openSelectedPackage(
    List<SubscriptionBundleEntity> bundles,
  ) async {
    final selectedIndex = _selectedPackageNotifier.value;
    if (selectedIndex == null) return;

    final selectedProgram = widget.selectedProgram;
    if (selectedProgram == null) return;

    if (selectedIndex >= bundles.length) return;

    await context.pushNamed(
      AppRoutes.subscriptionPlanDetails,
      arguments: SubscriptionPlanDetailsArgs(
        program: selectedProgram,
        bundle: bundles[selectedIndex],
      ),
    );
  }

  Future<void> _continueWithProfileStatus(
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

    await _openSelectedPackage(state.bundles);
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
            final selectedProgram = widget.selectedProgram;
            if (selectedProgram == null) return;
            _continueAfterProfileUpdate = true;
            context.read<SubscriptionPackagesViewModel>().doIntent(
              GetSubscriptionPackagesEvent(selectedProgram.programId),
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
}
