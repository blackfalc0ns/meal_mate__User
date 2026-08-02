import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_confirmation_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_methods_section.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_overview_section.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_price_details_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';

class FamilyPaymentSetupScreen extends StatelessWidget {
  const FamilyPaymentSetupScreen({super.key});

  static const _dataSource = FamilyProgramSetupFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final members = _dataSource.getMembers(locale);
    final selectedMember = _dataSource.getSelectedMemberDetails(locale);
    final summary = _dataSource.getSelectionSummary(locale);
    final priceDetails = _dataSource.getPaymentPriceDetails(locale);
    final paymentMethods = _dataSource.getPaymentMethods(locale);
    final overviewMembers = _dataSource.getOverviewMembers(locale);

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
                  const FamilyProgramStepper(currentStep: 3),
                  const SizedBox(height: Spacing.familyProgramMemberTopGap),
                  FamilyProgramMemberStrip(members: members),
                  const SizedBox(height: Spacing.md),
                  Text(
                    locale.family_payment_confirm_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  FamilyPaymentConfirmationSummaryCard(
                    member: selectedMember,
                    summary: summary,
                  ),
                  const SizedBox(height: Spacing.lg),
                  FamilyPaymentPriceDetailsCard(details: priceDetails),
                  const SizedBox(height: Spacing.md),
                  FamilyPaymentMethodsSection(methods: paymentMethods),
                  const SizedBox(height: Spacing.lg),
                  FamilyPaymentOverviewSection(members: overviewMembers),
                  const SizedBox(height: Spacing.lg),
                  const FamilyPaymentActions(),
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
