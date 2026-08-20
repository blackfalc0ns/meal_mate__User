import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
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
  int _selectedProgramIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final displayedPrograms =
        widget.programs.isNotEmpty
            ? widget.programs
            : [
              FamilyProgramUiModel(
                title: locale.family_program_balanced_title,
                description: locale.family_program_balanced_description,
                imageAsset: '',
              ),
              FamilyProgramUiModel(
                title: locale.family_program_weight_loss_title,
                description: locale.family_program_weight_loss_description,
                imageAsset: '',
              ),
              FamilyProgramUiModel(
                title: locale.family_program_muscle_title,
                description: locale.family_program_muscle_description,
                imageAsset: '',
              ),
            ];

    final displayedMembers =
        widget.members.isNotEmpty
            ? widget.members
            : [
              FamilyProgramMemberUiModel(
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

    return Scaffold(
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.familySetupHorizontalPadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  FamilySetupHeaderBadge(),
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
                  FamilyProgramGrid(
                    programs: displayedPrograms,
                    selectedIndex: _selectedProgramIndex,
                    onProgramSelected:
                        (index) => setState(
                          () => _selectedProgramIndex = index,
                        ),
                  ),
                  const SizedBox(
                    height: Spacing.familyProgramActionsTopGap,
                  ),
                  FamilyProgramActions(
                    nextText: locale.family_next_package_days,
                    nextIcon: Icons.calendar_month_rounded,
                    onNextPressed:
                        () => context.pushNamed(
                          AppRoutes.familyPackageDaysSetup,
                        ),
                  ),
                  const SizedBox(height: Spacing.xxxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
