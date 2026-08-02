import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_grid.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';

class FamilyProgramSetupScreen extends StatefulWidget {
  const FamilyProgramSetupScreen({super.key});

  @override
  State<FamilyProgramSetupScreen> createState() =>
      _FamilyProgramSetupScreenState();
}

class _FamilyProgramSetupScreenState extends State<FamilyProgramSetupScreen> {
  static const _dataSource = FamilyProgramSetupFakeDataSource();
  int _selectedProgramIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final members = _dataSource.getMembers(locale);
    final programs = _dataSource.getPrograms(locale);

    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,

        titleWidget: Column(
          children: [
            Text(
              locale.family_setup_title,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurface,
              ),
            ),
            Text(
              locale.family_setup_subtitle,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size8,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familySetupHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FamilySetupHeaderBadge(),
              const SizedBox(height: Spacing.familyProgramProgressTopGap),
              const FamilyProgramStepper(),
              const SizedBox(height: Spacing.familyProgramMemberTopGap),
              FamilyProgramMemberStrip(members: members),
              const SizedBox(height: Spacing.familyProgramSummaryTopGap),
              FamilyProgramSummaryCard(member: members.last),
              const SizedBox(height: Spacing.familyProgramTitleTopGap),
              Text(
                locale.family_program_choose_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.familyProgramGridTopGap),
              FamilyProgramGrid(
                programs: programs,
                selectedIndex: _selectedProgramIndex,
                onProgramSelected: (index) =>
                    setState(() => _selectedProgramIndex = index),
              ),
              const SizedBox(height: Spacing.familyProgramActionsTopGap),
              const FamilyProgramActions(),
              const SizedBox(height: Spacing.familyProgramBottomNavGap),
            ],
          ),
        ),
      ),
    );
  }
}
