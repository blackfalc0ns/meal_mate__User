import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_content.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_setup_loading_skeleton.dart';

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

    return BlocProvider<FamilyPackageDaysViewModel>(
      create: (_) {
        final vm = getIt<FamilyPackageDaysViewModel>();
        vm.doIntent(const GetFamilySubscriptionCurrentEvent());
        if (widget.programId != null && widget.programId!.isNotEmpty) {
          vm.doIntent(GetFamilyBundlesEvent(widget.programId!));
        } else {
          vm.doIntent(const GetFamilyProgramsEvent());
        }
        return vm;
      },
      child: Scaffold(
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
          child: BlocBuilder<FamilyPackageDaysViewModel, FamilyPlanState>(
            builder: (context, state) {
              if ((state.isLoading || state.isCurrentFlowLoading) &&
                  state.bundles.isEmpty &&
                  state.members.isEmpty) {
                return const FamilyPackageDaysSetupLoadingSkeleton();
              }

              return FamilyPackageDaysContent(
                state: state,
                programId: widget.programId,
                onNextPressed: () {
                  _savePlanAndProceed(context, state);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _savePlanAndProceed(BuildContext context, FamilyPlanState state) {
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
        programId.isNotEmpty &&
        bundle != null &&
        durationDays != null &&
        durationDays > 0 &&
        tier != null) {
      final tierInt = int.tryParse(tier.tier) ?? 1;
      context.read<FamilyPackageDaysViewModel>().doIntent(
        SaveFamilyMemberPlanEvent(
          memberId: member.memberId,
          programId: programId,
          bundleId: bundle.bundleId,
          tier: tierInt,
          durationDays: durationDays,
          includeFriday: state.includeFriday,
        ),
      );
    }

    final hasUnreadyMembers = state.members.any(
      (m) => m.memberId != member?.memberId && !m.isReady,
    );

    if (hasUnreadyMembers) {
      final nextIndex = state.members.indexWhere(
        (m) => m.memberId != member?.memberId && !m.isReady,
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
