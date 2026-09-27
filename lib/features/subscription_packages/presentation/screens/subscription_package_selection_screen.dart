import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_state.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_prerequisite_bottom_sheet.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_package_choice_card.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_packages_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_selected_program_card.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_family_package_banner.dart';

class SubscriptionPackageSelectionScreen extends StatefulWidget {
  const SubscriptionPackageSelectionScreen({super.key, this.selectedProgram});

  final SubscriptionProgramEntity? selectedProgram;

  @override
  State<SubscriptionPackageSelectionScreen> createState() =>
      _SubscriptionPackageSelectionScreenState();
}

class _SubscriptionPackageSelectionScreenState
    extends State<SubscriptionPackageSelectionScreen> {
  int? _selectedPackageIndex;
  int? _selectedPlanDetailsIndex;
  final bool _isFamilyPackageSelected = false;
  bool _continueAfterProfileUpdate = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final selectedProgram = widget.selectedProgram;

    return BlocProvider<SubscriptionProgramsViewModel>(
      create: (_) {
        final viewModel = getIt<SubscriptionProgramsViewModel>();
        if (selectedProgram != null) {
          viewModel.doIntent(
            GetSubscriptionProgramBundlesEvent(selectedProgram.programId),
          );
        }
        return viewModel;
      },
      child:
          BlocConsumer<
            SubscriptionProgramsViewModel,
            SubscriptionProgramsState
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
            builder: (context, state) => Scaffold(
              backgroundColor: color.surface,
              appBar: CustomAppBar(
                titleWidget: const AppLogo(
                  alignment: CrossAxisAlignment.center,
                ),
                backgroundColor: color.surface,
                onBackPressed: () => Navigator.maybePop(context),
              ),
              bottomNavigationBar:
                  BlocBuilder<
                    SubscriptionProgramsViewModel,
                    SubscriptionProgramsState
                  >(
                    builder: (context, state) {
                      return SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.lg,
                            vertical: Spacing.md,
                          ),
                          child: AppButton.filled(
                            text: locale.subscription_choose_plan_button,
                            onPressed:
                                _selectedPlanDetailsIndex == null ||
                                    state.bundles.isEmpty
                                ? null
                                : () => _continueWithProfileStatus(
                                    context,
                                    state,
                                  ),
                            isLoading: state.isLoading,
                            borderRadius: Spacing.radiusPill,
                            textColor: color.onPrimary,
                            fontSize: FontSize.size12,
                            iconWidget: Icon(
                              Icons.chevron_right_rounded,
                              color: color.onPrimary,
                              size: Spacing.iconMd,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              body:
                  BlocBuilder<
                    SubscriptionProgramsViewModel,
                    SubscriptionProgramsState
                  >(
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
    SubscriptionProgramsState state,
    SubscriptionProgramEntity? selectedProgram,
  ) {
    final color = context.colorScheme;
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
        onRetry: () => context.read<SubscriptionProgramsViewModel>().doIntent(
          GetSubscriptionProgramBundlesEvent(selectedProgram.programId),
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

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.xl,
          ),
          sliver: SliverList.separated(
            itemCount: _isFamilyPackageSelected ? 3 : state.bundles.length + 2,
            separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
            itemBuilder: (context, index) {
              if (index == 0) {
                return SubscriptionSelectedProgramCard(
                  program: selectedProgram,
                );
              }

              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: Spacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        locale.subscription_choose_plan_title,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (_isFamilyPackageSelected) {
                return SubscriptionFamilyPackageBanner(
                  onTap: () => context.pushNamed(AppRoutes.familyPlanDetails),
                );
              }

              final packageIndex = index - 2;
              final bundle = state.bundles[packageIndex];

              return SubscriptionPackageChoiceCard(
                title: bundle.name(locale.localeName),
                subtitle: _bundleSubtitle(bundle, locale.localeName),
                imageUrl: selectedProgram.imageUrl,
                fallbackImageAsset: selectedProgram.fallbackImageAsset,
                restaurantLogoUrls: bundle.restaurants
                    .map((restaurant) => restaurant.logoUrl)
                    .toList(),
                badgeLabel: bundle.badge?.name(locale.localeName),
                isSelected: packageIndex == _selectedPackageIndex,
                isPopular: bundle.isMostSelected,
                onTap: () => _selectPackage(packageIndex, packageIndex),
              );
            },
          ),
        ),
      ],
    );
  }

  String _bundleSubtitle(SubscriptionBundleEntity bundle, String localeName) {
    final slots = bundle.slots
        .where((slot) => slot.quantity > 0)
        .map((slot) => slot.name(localeName))
        .where((slotName) => slotName.isNotEmpty)
        .join(' - ');

    if (slots.isNotEmpty) return slots;
    return bundle.description(localeName);
  }

  void _selectPackage(int index, int planDetailsIndex) {
    setState(() {
      _selectedPackageIndex = index;
      _selectedPlanDetailsIndex = planDetailsIndex;
    });
  }

  void _openSelectedPackage(List<SubscriptionBundleEntity> bundles) {
    final selectedPlanDetailsIndex = _selectedPlanDetailsIndex;
    if (selectedPlanDetailsIndex == null) return;

    final selectedProgram = widget.selectedProgram;
    if (selectedProgram == null) return;

    if (selectedPlanDetailsIndex >= bundles.length) return;

    context.pushNamed(
      AppRoutes.subscriptionPlanDetails,
      arguments: SubscriptionPlanDetailsArgs(
        program: selectedProgram,
        bundle: bundles[selectedPlanDetailsIndex],
      ),
    );
  }

  Future<void> _continueWithProfileStatus(
    BuildContext context,
    SubscriptionProgramsState state,
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

    _openSelectedPackage(state.bundles);
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
            context.read<SubscriptionProgramsViewModel>().doIntent(
              GetSubscriptionProgramBundlesEvent(selectedProgram.programId),
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
