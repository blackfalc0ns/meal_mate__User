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
        }
        return vm;
      },
      child: isInFamilyFlow
          ? BlocBuilder<FamilyPackageDaysViewModel, FamilyPackageDaysState>(
              buildWhen: _shouldRebuildSetupScreen,
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
                    >(
                      buildWhen: _shouldRebuildSetupScreen,
                      builder: _buildContent,
                    ),
              ),
            ),
    );
  }

  bool _shouldRebuildSetupScreen(
    FamilyPackageDaysState previous,
    FamilyPackageDaysState current,
  ) {
    final prevHasMembers = previous.members.isNotEmpty;
    final currHasMembers = current.members.isNotEmpty;
    if (prevHasMembers != currHasMembers) return true;
    if (!currHasMembers) {
      return previous.isCurrentFlowLoading != current.isCurrentFlowLoading ||
          previous.failure != current.failure;
    }
    return false;
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
          }
        },
      );
    }

    return FamilyPackageDaysContent(
      programId: widget.programId,
      onNextPressed: () => _savePlanAndProceed(context),
    );
  }

  Future<void> _savePlanAndProceed(BuildContext context) async {
    final vm = context.read<FamilyPackageDaysViewModel>();
    var latestState = vm.state;
    final member =
        latestState.selectedMember ??
        (latestState.members.isNotEmpty ? latestState.members.first : null);
    final programId =
        widget.programId ??
        latestState.selectedProgram?.programId ??
        member?.programId ??
        (latestState.programs.isNotEmpty
            ? latestState.programs.first.programId
            : '');
    final bundle = latestState.selectedBundle;
    final duration = latestState.selectedDuration;
    final durationDays =
        duration?.durationDays ?? latestState.customDurationDays;
    final tier = latestState.selectedTier;

    if (member != null &&
        !latestState.isSelectedManagerPlanLocked &&
        programId.isNotEmpty &&
        bundle != null &&
        durationDays != null &&
        durationDays > 0 &&
        tier != null) {
      final tierInt = int.tryParse(tier.tier) ?? 1;
      final saved = await vm.saveMemberPlanAndWait(
        memberId: member.memberId,
        programId: programId,
        bundleId: bundle.bundleId,
        tier: tierInt,
        durationDays: durationDays,
        includeFriday: latestState.includeFriday,
      );
      if (!context.mounted) return;
      if (!saved) {
        final failure = vm.state.failure;
        if (failure != null) {
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.fromFailure(context, failure),
          );
        }
        return;
      }
      latestState = vm.state;
    }

    final hasUnreadyMembers = latestState.plannedMembers.any(
      (m) =>
          m.memberId != member?.memberId &&
          !latestState.isMemberPlanReady(m),
    );

    if (hasUnreadyMembers) {
      final nextIndex = latestState.members.indexWhere(
        (m) =>
            m.hasProgram &&
            m.memberId != member?.memberId &&
            !latestState.isMemberPlanReady(m),
      );
      if (nextIndex != -1) {
        vm.doIntent(SelectFamilyMemberPackageDaysEvent(nextIndex));
      }
      Navigator.maybePop(context);
    } else {
      context.pushNamed(AppRoutes.familyPaymentSetup);
    }
  }
}
