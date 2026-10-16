import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_event.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_view_model.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_content.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_state.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_view_model.dart';

class FamilyProgramSetupScreen extends StatelessWidget {
  const FamilyProgramSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider<FamilyProgramsViewModel>(
      create: (_) {
        final viewModel = getIt<FamilyProgramsViewModel>();
        if (!isInFamilyFlow) {
          viewModel.doIntent(
            GetFamilySubscriptionCurrentEvent(
              memberId: FamilyFlowScope.targetMemberIdOf(context),
            ),
          );
        } else {
          final flow = context
              .read<FamilySubscriptionFlowViewModel>()
              .state
              .flow ??
              getIt<FamilyFlowSnapshotStore>().current;
          if (flow != null) {
            viewModel.doIntent(SetFamilyFlowEvent(flow));
          }
        }
        viewModel.doIntent(const GetFamilyProgramsEvent());
        return viewModel;
      },
      child: MultiBlocListener(
        listeners: [
          if (isInFamilyFlow)
            BlocListener<
              FamilySubscriptionFlowViewModel,
              FamilySubscriptionFlowState
            >(
              listenWhen: (previous, current) =>
                  previous.flow != current.flow && current.flow != null,
              listener: (context, state) {
                context.read<FamilyProgramsViewModel>().doIntent(
                  SetFamilyFlowEvent(state.flow),
                );
              },
            ),
          BlocListener<FamilyProgramsViewModel, FamilyProgramsState>(
            listenWhen: (previous, current) =>
                previous.currentFlow?.name != current.currentFlow?.name &&
                current.currentFlow?.name != null,
            listener: (context, state) {
              FamilyFlowScope.updateFamilyName(
                context,
                state.currentFlow?.name,
              );
            },
          ),
          BlocListener<FamilyProgramsViewModel, FamilyProgramsState>(
            listenWhen: (previous, current) =>
                previous.isPlanSaving && !current.isPlanSaving,
            listener: (context, state) {
              if (state.failure != null) {
                CustomSnackbar.showError(
                  context: context,
                  message: ErrorMessagePresenter.fromFailure(
                    context,
                    state.failure!,
                  ),
                );
              } else {
                if (isInFamilyFlow && state.currentFlow != null) {
                  context
                      .read<FamilySubscriptionFlowViewModel>()
                      .updateFlow(state.currentFlow!);
                }
                unawaited(context.pushNamed(AppRoutes.familyAddresses));
              }
            },
          ),
        ],
        child: isInFamilyFlow
            ? BlocBuilder<FamilyProgramsViewModel, FamilyProgramsState>(
                buildWhen: shouldRebuildContent,
                builder: _buildContent,
              )
            : Scaffold(
                backgroundColor: color.surface,
                appBar: CustomAppBar(
                  showBackButton: true,
                  titleWidget: Column(
                    children: [
                      Text(
                        locale.family_setup_title,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: color.onSurface,
                        ),
                      ),
                      Text(
                        locale.family_setup_subtitle,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size9,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child:
                      BlocBuilder<FamilyProgramsViewModel, FamilyProgramsState>(
                        buildWhen: shouldRebuildContent,
                        builder: _buildContent,
                      ),
                ),
              ),
      ),
    );
  }

  static bool shouldRebuildContent(
    FamilyProgramsState previous,
    FamilyProgramsState current,
  ) {
    return previous.currentFlow != current.currentFlow ||
        previous.programs != current.programs ||
        previous.selectedMemberIndex != current.selectedMemberIndex ||
        previous.selectedProgramIndex != current.selectedProgramIndex ||
        previous.isCurrentFlowLoading != current.isCurrentFlowLoading ||
        previous.isProgramsLoading != current.isProgramsLoading ||
        previous.isLoadingMorePrograms != current.isLoadingMorePrograms ||
        previous.hasMorePrograms != current.hasMorePrograms ||
        previous.isPlanSaving != current.isPlanSaving ||
        (current.programs.isEmpty && previous.failure != current.failure);
  }

  Widget _buildContent(BuildContext context, FamilyProgramsState state) {
    if (state.isLoading && state.programs.isEmpty && state.members.isEmpty) {
      return const FamilyProgramSetupLoadingSkeleton();
    }

    if (state.failure != null && state.programs.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () {
          context.read<FamilyProgramsViewModel>().doIntent(
            const GetFamilyProgramsEvent(),
          );
          context.read<FamilyProgramsViewModel>().doIntent(
            const GetFamilySubscriptionCurrentEvent(),
          );
        },
      );
    }

    final color = context.colorScheme;
    return Stack(
      children: [
        FamilyProgramContent(state: state),
        if (state.isPlanSaving)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: color.scrim.withValues(alpha: 0.32),
                child: const Center(child: CustomProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }
}
