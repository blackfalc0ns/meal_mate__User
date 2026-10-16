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
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_content.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyPackageDaysSetupScreen extends StatefulWidget {
  const FamilyPackageDaysSetupScreen({super.key, this.programId});

  final String? programId;

  @override
  State<FamilyPackageDaysSetupScreen> createState() =>
      _FamilyPackageDaysSetupScreenState();
}

class _FamilyPackageDaysSetupScreenState
    extends State<FamilyPackageDaysSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider<FamilyPackageDaysViewModel>(
      create: (_) {
        final vm = getIt<FamilyPackageDaysViewModel>();
        vm.doIntent(
          GetFamilySubscriptionCurrentEvent(
            memberId: FamilyFlowScope.targetMemberIdOf(context),
          ),
        );
        if (widget.programId != null && widget.programId!.isNotEmpty) {
          vm.doIntent(GetFamilyBundlesEvent(widget.programId!));
        } else {
          vm.doIntent(const GetFamilyProgramsEvent());
        }
        return vm;
      },
      child: isInFamilyFlow
          ? BlocBuilder<FamilyPackageDaysViewModel, FamilyPackageDaysState>(
              builder: _buildContent,
            )
          : Scaffold(
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
                    BlocBuilder<
                      FamilyPackageDaysViewModel,
                      FamilyPackageDaysState
                    >(builder: _buildContent),
              ),
            ),
    );
  }

  Widget _buildContent(BuildContext context, FamilyPackageDaysState state) {
    if ((state.isLoading || state.isCurrentFlowLoading) &&
        state.members.isEmpty) {
      return const FamilyPackageDaysSetupLoadingSkeleton();
    }

    if (state.failure != null && state.members.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () {
          final vm = context.read<FamilyPackageDaysViewModel>();
          vm.doIntent(
            GetFamilySubscriptionCurrentEvent(
              memberId: FamilyFlowScope.targetMemberIdOf(context),
            ),
          );
          if (widget.programId != null && widget.programId!.isNotEmpty) {
            vm.doIntent(GetFamilyBundlesEvent(widget.programId!));
          } else {
            vm.doIntent(const GetFamilyProgramsEvent());
          }
        },
      );
    }

    return FamilyPackageDaysContent(
      state: state,
      programId: widget.programId,
      onNextPressed: () => _savePlanAndProceed(context, state),
    );
  }

  Future<void> _savePlanAndProceed(
    BuildContext context,
    FamilyPackageDaysState state,
  ) async {
    var latestState = state;
    final member =
        state.selectedMember ??
        (state.members.isNotEmpty ? state.members.first : null);
    final programId =
        widget.programId ??
        state.selectedProgram?.programId ??
        member?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : '');
    final bundle = state.selectedBundle;
    final duration = state.selectedDuration;
    final durationDays = duration?.durationDays ?? state.customDurationDays;
    final tier = state.selectedTier;

    if (member != null &&
        !state.isSelectedManagerPlanLocked &&
        programId.isNotEmpty &&
        bundle != null &&
        durationDays != null &&
        durationDays > 0 &&
        tier != null) {
      final tierInt = int.tryParse(tier.tier) ?? 1;
      final saved = await context
          .read<FamilyPackageDaysViewModel>()
          .saveMemberPlanAndWait(
            memberId: member.memberId,
            programId: programId,
            bundleId: bundle.bundleId,
            tier: tierInt,
            durationDays: durationDays,
            includeFriday: state.includeFriday,
          );
      if (!context.mounted) return;
      if (!saved) {
        final failure = context
            .read<FamilyPackageDaysViewModel>()
            .state
            .failure;
        if (failure != null) {
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.fromFailure(context, failure),
          );
        }
        return;
      }
      latestState = context.read<FamilyPackageDaysViewModel>().state;
    }

    final hasUnreadyMembers = latestState.plannedMembers.any(
      (m) => m.memberId != member?.memberId && !m.isReady,
    );

    if (hasUnreadyMembers) {
      final nextIndex = latestState.members.indexWhere(
        (m) => m.hasProgram && m.memberId != member?.memberId && !m.isReady,
      );
      if (nextIndex != -1) {
        context.read<FamilyPackageDaysViewModel>().doIntent(
          SelectFamilyMemberEvent(nextIndex),
        );
      }
      Navigator.maybePop(context);
    } else {
      context.pushNamed(AppRoutes.familyPaymentSetup);
    }
  }
}
