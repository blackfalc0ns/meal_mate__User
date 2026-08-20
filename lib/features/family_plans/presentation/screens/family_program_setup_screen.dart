import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_view_model.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_grid.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';

class FamilyProgramSetupScreen extends StatefulWidget {
  const FamilyProgramSetupScreen({
    super.key,
    this.members = const [],
    this.selectedMember,
    this.programs = const [],
  });

  final List<FamilyProgramMemberUiModel> members;
  final FamilyProgramMemberDetailsUiModel? selectedMember;
  final List<FamilyProgramUiModel> programs;

  @override
  State<FamilyProgramSetupScreen> createState() =>
      _FamilyProgramSetupScreenState();
}

class _FamilyProgramSetupScreenState extends State<FamilyProgramSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final displayedMembers =
        widget.members.isNotEmpty
            ? widget.members
            : [
              const FamilyProgramMemberUiModel(
                name: 'Yahya',
                imageAsset: '',
                status: '',
                isSelected: true,
                isInProgress: true,
              ),
            ];

    final activeMember =
        widget.selectedMember ??
        (displayedMembers.isNotEmpty
            ? FamilyProgramMemberDetailsUiModel(
              name: displayedMembers.first.name,
              imageAsset: '',
              age: '28',
              gender: '',
              goal: '',
              activityLevel: '',
            )
            : null);

    return BlocProvider<FamilyPlanViewModel>(
      create: (_) => getIt<FamilyPlanViewModel>()
        ..doIntent(const GetFamilyProgramsEvent()),
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
          child: BlocBuilder<FamilyPlanViewModel, FamilyPlanState>(
            builder: (context, state) {
              final displayedPrograms =
                  state.programs
                      .map(
                        (p) => FamilyProgramUiModel(
                          title: p.name(locale.localeName),
                          description: p.description(locale.localeName),
                          imageAsset:
                              p.imageUrl != null && p.imageUrl!.isNotEmpty
                                  ? p.imageUrl!
                                  : p.fallbackImageAsset,
                        ),
                      )
                      .toList();

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.familySetupHorizontalPadding,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        const FamilySetupHeaderBadge(),
                        const SizedBox(
                          height: Spacing.familyProgramProgressTopGap,
                        ),
                        const FamilyProgramStepper(
                          currentStep: 1,
                          includeFamilyCreationStep: true,
                        ),
                        const SizedBox(
                          height: Spacing.familyProgramMemberTopGap,
                        ),
                        if (displayedMembers.isNotEmpty)
                          FamilyProgramMemberStrip(members: displayedMembers),
                        const SizedBox(
                          height: Spacing.familyProgramSummaryTopGap,
                        ),
                        if (activeMember != null)
                          FamilyProgramSummaryCard(member: activeMember),
                        const SizedBox(height: Spacing.familyProgramTitleTopGap),
                        Text(
                          locale.family_program_choose_title,
                          textAlign: TextAlign.center,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.familyProgramGridTopGap),
                        if (state.isLoading && state.programs.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Spacing.xl,
                            ),
                            child: Center(child: LoadingWidget()),
                          )
                        else
                          FamilyProgramGrid(
                            programs: displayedPrograms,
                            selectedIndex: state.selectedProgramIndex,
                            onProgramSelected: (index) {
                              context.read<FamilyPlanViewModel>().doIntent(
                                    SelectFamilyProgramEvent(index),
                                  );
                            },
                          ),
                        const SizedBox(
                          height: Spacing.familyProgramActionsTopGap,
                        ),
                        FamilyProgramActions(
                          nextText: locale.family_next_package_days,
                          nextIcon: Icons.calendar_month_rounded,
                          onNextPressed: () {
                            final programId = state.selectedProgram?.programId ??
                                (state.programs.isNotEmpty &&
                                        state.selectedProgramIndex <
                                            state.programs.length
                                    ? state
                                        .programs[state.selectedProgramIndex]
                                        .programId
                                    : null);
                            context.pushNamed(
                              AppRoutes.familyPackageDaysSetup,
                              arguments: programId,
                            );
                          },
                        ),
                        const SizedBox(height: Spacing.xxxl),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

