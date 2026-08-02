import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_day_options_row.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_friday_delivery_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_package_options_grid.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_note_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_selection_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';

class FamilyPackageDaysSetupScreen extends StatefulWidget {
  const FamilyPackageDaysSetupScreen({super.key});

  @override
  State<FamilyPackageDaysSetupScreen> createState() =>
      _FamilyPackageDaysSetupScreenState();
}

class _FamilyPackageDaysSetupScreenState
    extends State<FamilyPackageDaysSetupScreen> {
  static const _dataSource = FamilyProgramSetupFakeDataSource();
  int _selectedPackageIndex = 0;
  int _selectedDayIndex = 0;
  bool _fridayDeliverySelected = true;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final members = _dataSource.getMembers(locale);
    final selectedMember = _dataSource.getSelectedMemberDetails(locale);
    final packageOptions = _dataSource.getPackageOptions(locale);
    final selectedPackageOptions = List<FamilyPackageOptionFakeData>.generate(
      packageOptions.length,
      (index) => FamilyPackageOptionFakeData(
        title: packageOptions[index].title,
        description: packageOptions[index].description,
        icon: packageOptions[index].icon,
        isSelected: index == _selectedPackageIndex,
      ),
    );
    final dayOptions = _dataSource.getDayOptions(locale);
    final selectedDayOptions = List<FamilyDayOptionFakeData>.generate(
      dayOptions.length,
      (index) => FamilyDayOptionFakeData(
        label: dayOptions[index].label,
        isSelected: index == _selectedDayIndex,
      ),
    );
    final summary = _dataSource.getPackageDaysSelectionSummary(locale);

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
                  const SizedBox(height: Spacing.familyProgramProgressTopGap),
                  const FamilyProgramStepper(currentStep: 2),
                  const SizedBox(height: Spacing.familyProgramMemberTopGap),
                  FamilyProgramMemberStrip(members: members),
                  const SizedBox(height: Spacing.familyProgramSummaryTopGap),
                  FamilyProgramSummaryCard(member: selectedMember),
                  const SizedBox(height: Spacing.familyPackageTitleTopGap),
                  Text(
                    locale.family_package_choose_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    locale.family_package_choose_subtitle,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.familyPackageOptionsTopGap),
                  FamilyPackageOptionsGrid(
                    options: selectedPackageOptions,
                    onOptionSelected: (index) =>
                        setState(() => _selectedPackageIndex = index),
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    locale.family_days_choose_title,

                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.base),
                  FamilyDayOptionsRow(
                    options: selectedDayOptions,
                    onOptionSelected: (index) =>
                        setState(() => _selectedDayIndex = index),
                  ),
                  const SizedBox(height: Spacing.lg),
                  FamilyFridayDeliveryCard(
                    selected: _fridayDeliverySelected,
                    onChanged: (selected) =>
                        setState(() => _fridayDeliverySelected = selected),
                  ),
                  const SizedBox(height: Spacing.lg),
                  FamilySelectionSummaryCard(summary: summary),
                  const SizedBox(height: Spacing.lg),
                  const FamilyPaymentNoteCard(),
                  const SizedBox(height: Spacing.md),
                  FamilyProgramActions(
                    nextText: locale.family_next_payment,
                    nextIcon: Icons.credit_card_rounded,
                    onNextPressed: () =>
                        context.pushNamed(AppRoutes.familyPaymentSetup),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
