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
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_view_model.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_grid.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';

class FamilyProgramSetupScreen extends StatelessWidget {
  const FamilyProgramSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilyPlanViewModel>(
      create: (_) => getIt<FamilyPlanViewModel>()
        ..doIntent(const GetFamilySubscriptionCurrentEvent())
        ..doIntent(const GetFamilyProgramsEvent()),
      child: Scaffold(
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
          child: BlocBuilder<FamilyPlanViewModel, FamilyPlanState>(
            builder: (context, state) {
              if (state.isLoading &&
                  state.programs.isEmpty &&
                  state.members.isEmpty) {
                return const FamilyProgramSetupLoadingSkeleton();
              }

              if (state.failure != null && state.programs.isEmpty) {
                return ApiErrorWidget(
                  exception: state.failure!.exception,
                  onRetry: () {
                    context
                        .read<FamilyPlanViewModel>()
                        .doIntent(const GetFamilyProgramsEvent());
                    context
                        .read<FamilyPlanViewModel>()
                        .doIntent(const GetFamilySubscriptionCurrentEvent());
                  },
                );
              }

              return _buildContent(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FamilyPlanState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    final members = state.members;
    final selectedMember = state.selectedMember;

    final displayedMembers = members.asMap().entries.map((entry) {
      final index = entry.key;
      final m = entry.value;
      final isSelected = index == state.selectedMemberIndex;
      final hasProgram = m.programId != null && m.programId!.isNotEmpty;
      return FamilyProgramMemberUiModel(
        name: m.displayName,
        imageAsset: '',
        status: hasProgram
            ? locale.family_member_completed
            : locale.family_member_in_progress,
        isSelected: isSelected,
        isInProgress: !hasProgram,
      );
    }).toList();

    final activeMemberDetails = selectedMember != null
        ? FamilyProgramMemberDetailsUiModel(
            name: selectedMember.displayName,
            imageAsset: '',
            age: '${selectedMember.ageYears} ${locale.family_year}',
            gender: selectedMember.gender == 2
                ? locale.family_gender_female
                : locale.family_gender_male,
            roleLabel: selectedMember.isManager ? locale.family_owner : '',
          )
        : (members.isNotEmpty
            ? FamilyProgramMemberDetailsUiModel(
                name: members.first.displayName,
                imageAsset: '',
                age: '${members.first.ageYears} ${locale.family_year}',
                gender: members.first.gender == 2
                    ? locale.family_gender_female
                    : locale.family_gender_male,
                roleLabel:
                    members.first.isManager ? locale.family_owner : '',
              )
            : null);

    final selectedProgramId = selectedMember?.programId;
    final int? effectiveProgIndex;
    if (selectedProgramId != null && selectedProgramId.isNotEmpty) {
      final found =
          state.programs.indexWhere((p) => p.programId == selectedProgramId);
      effectiveProgIndex = found != -1 ? found : null;
    } else {
      effectiveProgIndex = state.selectedProgramIndex;
    }

    final displayedPrograms = state.programs
        .asMap()
        .entries
        .map(
          (entry) => FamilyProgramUiModel(
            title: entry.value.name(locale.localeName),
            description: entry.value.description(locale.localeName),
            imageAsset: entry.value.imageUrl != null &&
                    entry.value.imageUrl!.isNotEmpty
                ? entry.value.imageUrl!
                : entry.value.fallbackImageAsset,
            isSelected: effectiveProgIndex != null &&
                entry.key == effectiveProgIndex,
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
              FamilySetupHeaderBadge(
                title: state.currentFlow?.name,
              ),
              const SizedBox(height: Spacing.familyProgramProgressTopGap),
              const FamilyProgramStepper(
                currentStep: 1,
                includeFamilyCreationStep: true,
              ),
              const SizedBox(height: Spacing.familyProgramMemberTopGap),

              // Scrollable Member Strip
              if (displayedMembers.isNotEmpty) ...[
                FamilyProgramMemberStrip(
                  members: displayedMembers,
                  onSelectMember: (index) {
                    context
                        .read<FamilyPlanViewModel>()
                        .doIntent(SelectFamilyMemberEvent(index));
                  },
                ),
                const SizedBox(height: Spacing.familyProgramSummaryTopGap),
              ],

              // Active Member Summary Card
              if (activeMemberDetails != null) ...[
                FamilyProgramSummaryCard(member: activeMemberDetails),
                const SizedBox(height: Spacing.familyProgramTitleTopGap),
              ],

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

              if (displayedPrograms.isEmpty)
                EmptyStateWidget(
                  title: locale.family_program_choose_title,
                  description: locale.family_packages_selection_subtitle,
                  icon: Icons.restaurant_menu_rounded,
                )
              else
                FamilyProgramGrid(
                  programs: displayedPrograms,
                  selectedIndex: effectiveProgIndex,
                  onProgramSelected: (index) {
                    context
                        .read<FamilyPlanViewModel>()
                        .doIntent(SelectFamilyProgramEvent(index));
                  },
                ),

              const SizedBox(height: Spacing.lg),
              FamilyProgramActions(
                nextText: locale.family_next_package_days,
                nextIcon: Icons.arrow_forward_ios_rounded,
                onNextPressed: () {
                  final unreadyIndex = state.members.indexWhere(
                    (m) => m.programId == null || m.programId!.isEmpty,
                  );
                  if (unreadyIndex != -1) {
                    context.read<FamilyPlanViewModel>().doIntent(
                          SelectFamilyMemberEvent(unreadyIndex),
                        );
                    return;
                  }
                  final firstProgramId = state.members.firstOrNull?.programId ??
                      state.selectedProgram?.programId;
                  context.pushNamed(
                    AppRoutes.familyPackageDaysSetup,
                    arguments: firstProgramId,
                  );
                },
              ),
              const SizedBox(height: Spacing.xxxl),
            ]),
          ),
        ),
      ],
    );
  }
}
