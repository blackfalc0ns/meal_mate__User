import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_flow_args.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_state.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_view_model.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_address_required_sheet.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_selection_view.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_programs_loading_skeleton.dart';

class SubscriptionProgramSelectionScreen extends StatefulWidget {
  const SubscriptionProgramSelectionScreen({super.key});

  @override
  State<SubscriptionProgramSelectionScreen> createState() =>
      _SubscriptionProgramSelectionScreenState();
}

class _SubscriptionProgramSelectionScreenState
    extends State<SubscriptionProgramSelectionScreen> {
  final ValueNotifier<int?> _selectedProgramNotifier = ValueNotifier<int?>(
    null,
  );
  bool _isAddressPromptShown = false;
  bool _isAddressSheetOpen = false;

  @override
  void dispose() {
    _selectedProgramNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<SubscriptionProgramsViewModel>(
      create: (_) =>
          getIt<SubscriptionProgramsViewModel>()
            ..doIntent(const GetSubscriptionProgramsEvent()),
      child: Semantics(
        label: locale.nav_subscription,
        child: BlocListener<
          SubscriptionProgramsViewModel,
          SubscriptionProgramsState
        >(
          listenWhen: (previous, current) =>
              (!previous.isSuccess && current.isSuccess) ||
              (previous.hasDeliveryAddress != current.hasDeliveryAddress),
          listener: (context, state) {
            if (state.isAddressRequired && !_isAddressPromptShown) {
              _isAddressPromptShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  unawaited(_openAddressRequiredFlow());
                }
              });
            }
          },
          child: Scaffold(
            backgroundColor: color.surface,
            body: Stack(
              children: [
                BlocBuilder<
                  SubscriptionProgramsViewModel,
                  SubscriptionProgramsState
                >(
                  buildWhen: (previous, current) =>
                      previous.isLoading != current.isLoading ||
                      previous.isRefreshing != current.isRefreshing ||
                      previous.isLoadingMore != current.isLoadingMore ||
                      previous.isSuccess != current.isSuccess ||
                      previous.failure != current.failure ||
                      previous.loadMoreFailure != current.loadMoreFailure ||
                      previous.programs != current.programs,
                  builder: _buildBody,
                ),
                CustomBackButton(
                  top: MediaQuery.paddingOf(context).top + Spacing.base,
                  onPressed: () => Navigator.maybePop(context),
                ),
                BlocSelector<
                  SubscriptionProgramsViewModel,
                  SubscriptionProgramsState,
                  ({List<SubscriptionProgramEntity> programs, bool isAddressRequired})
                >(
                  selector: (state) => (
                    programs: state.programs,
                    isAddressRequired: state.isAddressRequired,
                  ),
                  builder: (context, data) {
                    final programs = data.programs;
                    final isAddressRequired = data.isAddressRequired;

                    return PositionedDirectional(
                      start: Spacing.subscriptionProgramsHorizontalPadding,
                      end: Spacing.subscriptionProgramsHorizontalPadding,
                      bottom: Spacing.lg,
                      child:
                          SafeArea(
                                top: false,
                                child: ValueListenableBuilder<int?>(
                                  valueListenable: _selectedProgramNotifier,
                                  builder: (context, selectedProgramIndex, _) {
                                    if (isAddressRequired) {
                                      return AppSubscriptionButton.next(
                                        text: locale
                                            .subscription_program_address_required_action,
                                        onPressed: _openAddressRequiredFlow,
                                      );
                                    }

                                    final selectedProgram =
                                        (selectedProgramIndex != null &&
                                            selectedProgramIndex >= 0 &&
                                            selectedProgramIndex <
                                                programs.length)
                                        ? programs[selectedProgramIndex]
                                        : null;
                                    final isEnabled =
                                        selectedProgram != null &&
                                        selectedProgram.canSelect;

                                    return AppSubscriptionButton.next(
                                      text: locale.family_next_package_days,
                                      onPressed: isEnabled
                                          ? () => _openPackageSelection(programs)
                                          : null,
                                    );
                                  },
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                              .slideY(
                                begin: 0.15,
                                end: 0,
                                duration: 350.ms,
                                curve: Curves.easeOutCubic,
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SubscriptionProgramsState state) {
    final locale = context.localization;

    if (state.isLoading && state.programs.isEmpty) {
      return const SubscriptionProgramsLoadingSkeleton();
    }

    if (state.failure != null && state.programs.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => context.read<SubscriptionProgramsViewModel>().doIntent(
          const GetSubscriptionProgramsEvent(),
        ),
      );
    }

    if (state.isSuccess && state.programs.isEmpty) {
      return EmptyStateWidget(
        title: locale.subscription_programs_empty_title,
        description: locale.subscription_programs_empty_description,
        icon: Icons.restaurant_menu_rounded,
      );
    }

    return SubscriptionProgramSelectionView(
      showBottomSpace: true,
      programs: state.programs,
      selectedProgramNotifier: _selectedProgramNotifier,
      onProgramSelected: _selectProgram,
      isLoadingMore: state.isLoadingMore,
      loadMoreFailure: state.loadMoreFailure,
      onAddressRequired: _openAddressRequiredFlow,
      onLoadMore: () => context.read<SubscriptionProgramsViewModel>().doIntent(
        const LoadMoreSubscriptionProgramsEvent(),
      ),
      onRetryLoadMore: () => context
          .read<SubscriptionProgramsViewModel>()
          .doIntent(const RetrySubscriptionProgramsEvent()),
    );
  }

  void _selectProgram(int index) {
    if (_selectedProgramNotifier.value == index) return;
    _selectedProgramNotifier.value = index;
  }

  Future<void> _openAddressRequiredFlow() async {
    if (_isAddressSheetOpen || !mounted) return;
    _isAddressSheetOpen = true;

    try {
      final shouldAddAddress = await AppWoltModalSheet.show<bool>(
        context: context,
        title: context
            .localization.subscription_program_address_required_title,
        child: SubscriptionProgramAddressRequiredSheet(
          onAddAddress: () => Navigator.of(context).pop(true),
          onDismiss: () => Navigator.of(context).pop(false),
        ),
      );

      if (!mounted) return;

      if (shouldAddAddress == true) {
        final result = await Navigator.of(context).pushNamed(
          AppRoutes.addressChooseLocation,
          arguments: const SubscriptionFlowArgs(),
        );

        if (!mounted) return;

        if (result == true) {
          _isAddressPromptShown = false;
          if (mounted) {
            context.read<SubscriptionProgramsViewModel>().doIntent(
              const GetSubscriptionProgramsEvent(isRefresh: true),
            );
          }
        }
      }
    } finally {
      _isAddressSheetOpen = false;
    }
  }

  void _openPackageSelection(List<SubscriptionProgramEntity> programs) {
    final selectedProgramIndex = _selectedProgramNotifier.value;
    if (selectedProgramIndex == null ||
        selectedProgramIndex < 0 ||
        selectedProgramIndex >= programs.length) {
      return;
    }
    if (!programs[selectedProgramIndex].canSelect) {
      return;
    }

    unawaited(
      context.pushNamed(
        AppRoutes.subscriptionPackageSelection,
        arguments: programs[selectedProgramIndex],
      ),
    );
  }
}
