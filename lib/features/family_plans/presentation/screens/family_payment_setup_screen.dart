import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_confirmation_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_methods_section.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_overview_section.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_price_details_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';

class FamilyPaymentSetupScreen extends StatelessWidget {
  const FamilyPaymentSetupScreen({
    super.key,
    this.members = const [],
    this.selectedMember,
    this.summary,
    this.priceDetails,
    this.paymentMethods = const [],
    this.overviewMembers = const [],
  });

  final List<FamilyProgramMemberUiModel> members;
  final FamilyProgramMemberDetailsUiModel? selectedMember;
  final FamilySelectionSummaryData? summary;
  final FamilyPaymentPriceDetailsUiModel? priceDetails;
  final List<FamilyPaymentMethodUiModel> paymentMethods;
  final List<FamilyPlanMemberUiModel> overviewMembers;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final displayedMembers =
        members.isNotEmpty
            ? members
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
        selectedMember ??
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

    final selectionSummary =
        summary ??
        FamilySelectionSummaryData(
          title: locale.family_subscription_summary,
          rows: [
            FamilySelectionSummaryRowData(
              icon: FamilySelectionSummaryIcon.balance,
              label: locale.family_subscription_program_label,
              value: locale.family_subscription_program_value,
            ),
            FamilySelectionSummaryRowData(
              icon: FamilySelectionSummaryIcon.cutlery,
              label: locale.family_subscription_package_label,
              value: locale.family_package_two_meals_title,
            ),
            FamilySelectionSummaryRowData(
              icon: FamilySelectionSummaryIcon.calendar,
              label: locale.family_subscription_days_label,
              value: locale.family_days_30,
            ),
            FamilySelectionSummaryRowData(
              icon: FamilySelectionSummaryIcon.check,
              label: locale.family_friday_delivery_title,
              value: locale.family_friday_delivery_added,
            ),
            FamilySelectionSummaryRowData(
              icon: FamilySelectionSummaryIcon.receipt,
              label: locale.family_total,
              value: '270.000',
              isPrice: true,
            ),
          ],
        );

    final details =
        priceDetails ??
        FamilyPaymentPriceDetailsUiModel(
          badge: '10%',
          note: locale.family_payment_note,
          totalLabel: locale.family_monthly_total_label,
          totalValue: '270.000',
          rows: [
            FamilyPaymentPriceRowUiModel(
              label: locale.family_price_duration_total,
              value: '300.000',
            ),
            FamilyPaymentPriceRowUiModel(
              label: locale.family_price_discount,
              value: '-30.000',
              isDiscount: true,
            ),
            FamilyPaymentPriceRowUiModel(
              label: locale.family_monthly_total_label,
              value: '270.000',
              isStrong: true,
            ),
          ],
        );

    final methods =
        paymentMethods.isNotEmpty
            ? paymentMethods
            : [
              FamilyPaymentMethodUiModel(
                label: locale.family_payment_apple_pay_label,
                imageAsset: '',
                selected: true,
              ),
              const FamilyPaymentMethodUiModel(
                label: 'KNET',
                imageAsset: '',
              ),
              FamilyPaymentMethodUiModel(
                label: locale.family_payment_card_label,
                imageAsset: '',
              ),
            ];

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
                    currentStep: 3,
                    includeFamilyCreationStep: true,
                  ),
                  const SizedBox(
                    height: Spacing.familyProgramMemberTopGap,
                  ),
                  if (displayedMembers.isNotEmpty)
                    FamilyProgramMemberStrip(members: displayedMembers),
                  const SizedBox(height: Spacing.md),
                  Text(
                    locale.family_payment_confirm_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                  ),
                  if (activeMember != null) ...[
                    const SizedBox(height: Spacing.md),
                    FamilyPaymentConfirmationSummaryCard(
                      member: activeMember,
                      summary: selectionSummary,
                    ),
                  ],
                  const SizedBox(height: Spacing.lg),
                  FamilyPaymentPriceDetailsCard(details: details),
                  const SizedBox(height: Spacing.md),
                  FamilyPaymentMethodsSection(methods: methods),
                  if (overviewMembers.isNotEmpty) ...[
                    const SizedBox(height: Spacing.lg),
                    FamilyPaymentOverviewSection(
                      members: overviewMembers,
                    ),
                  ],
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
