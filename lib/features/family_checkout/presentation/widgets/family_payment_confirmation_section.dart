import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_view_model.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_confirmation_summary_card.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyPaymentConfirmationSection extends StatelessWidget {
  const FamilyPaymentConfirmationSection({super.key, required this.state});

  final FamilyCheckoutState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final languageCode = Localizations.localeOf(context).languageCode;
    final summary = state.summary;
    final selectedMemberSummary = summary?.selectedMember;
    final activeMemberDetails = _activeMemberDetails(context);
    final activeMemberId =
        selectedMemberSummary?.memberId ??
        state.selectedSummaryMemberId ??
        summary?.selectedMemberId ??
        state.members.firstOrNull?.memberId;
    final matchingFlowMember = state.members
        .where((m) => m.memberId == activeMemberId)
        .firstOrNull;
    final isSubscribed = matchingFlowMember?.subscribeNow ?? false;
    final selectionSummary = selectedMemberSummary == null
        ? null
        : _selectionSummary(
            locale: locale,
            languageCode: languageCode,
            currency: _currency(context, summary),
            managerPrepaid: summary?.managerPrepaid ?? false,
            selectedMemberSummary: selectedMemberSummary,
            startDate: matchingFlowMember?.startDate,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.family_payment_confirm_title,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        if (activeMemberDetails != null && selectionSummary != null) ...[
          const SizedBox(height: Spacing.md),
          FamilyPaymentConfirmationSummaryCard(
            member: activeMemberDetails,
            summary: selectionSummary,
            isSubscribed: isSubscribed,
            onToggleSubscription: (value) {
              if (activeMemberId == null) return;
              context.read<FamilyCheckoutViewModel>().doIntent(
                SelectFamilyMemberCheckoutEvent(
                  memberId: activeMemberId,
                  subscribeNow: value,
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  FamilyProgramMemberDetailsUiModel? _activeMemberDetails(
    BuildContext context,
  ) {
    final locale = context.localization;
    final selectedMemberSummary = state.summary?.selectedMember;
    final fallbackMembers = state.members;

    if (selectedMemberSummary != null) {
      return FamilyProgramMemberDetailsUiModel(
        name: selectedMemberSummary.displayName,
        imageAsset: '',
        age: '',
        gender: '',
        roleLabel:
            selectedMemberSummary.roleAr ??
            (selectedMemberSummary.isManager
                ? locale.family_primary_member
                : ''),
      );
    }

    if (fallbackMembers.isEmpty) return null;

    return FamilyProgramMemberDetailsUiModel(
      name: fallbackMembers.first.displayName,
      imageAsset: '',
      age: '',
      gender: '',
      roleLabel: fallbackMembers.first.isManager
          ? locale.family_primary_member
          : '',
    );
  }

  FamilySelectionSummaryData? _selectionSummary({
    required dynamic locale,
    required String languageCode,
    required String currency,
    required bool managerPrepaid,
    required FamilySelectedMemberSummaryEntity selectedMemberSummary,
    String? startDate,
  }) {
    final rows = <FamilySelectionSummaryRowData>[];
    final programName = selectedMemberSummary.programName(languageCode);
    final bundleName = selectedMemberSummary.bundleName(languageCode);
    final durationText = selectedMemberSummary.durationText(languageCode);
    final tierText = selectedMemberSummary.tierText(languageCode);

    if (programName.isNotEmpty) {
      rows.add(
        FamilySelectionSummaryRowData(
          icon: FamilySelectionSummaryIcon.check,
          label: locale.family_subscription_program_label,
          value: programName,
        ),
      );
    }

    if (bundleName.isNotEmpty) {
      rows.add(
        FamilySelectionSummaryRowData(
          icon: FamilySelectionSummaryIcon.cutlery,
          label: locale.family_subscription_package_label,
          value: bundleName,
        ),
      );
    }

    if (durationText.isNotEmpty) {
      rows.add(
        FamilySelectionSummaryRowData(
          icon: FamilySelectionSummaryIcon.calendar,
          label: locale.family_subscription_days_label,
          value: durationText,
        ),
      );
    }

    if (tierText.isNotEmpty) {
      rows.add(
        FamilySelectionSummaryRowData(
          icon: FamilySelectionSummaryIcon.balance,
          label: locale.subscription_summary_restaurant_tier_label,
          value: tierText,
        ),
      );
    }

    if (selectedMemberSummary.memberPrice > 0) {
      rows.add(
        FamilySelectionSummaryRowData(
          icon: FamilySelectionSummaryIcon.receipt,
          label: locale.family_weekly_price,
          value:
              '${selectedMemberSummary.memberPrice.toStringAsFixed(3)} $currency',
          isPrice: true,
        ),
      );
    } else if (managerPrepaid && selectedMemberSummary.isManager) {
      rows.add(
        FamilySelectionSummaryRowData(
          icon: FamilySelectionSummaryIcon.receipt,
          label: locale.family_weekly_price,
          value: locale.billing_paid,
          isPrice: true,
        ),
      );
    }

    if (rows.isEmpty) return null;

    return FamilySelectionSummaryData(
      title: locale.family_subscription_summary,
      rows: rows,
    );
  }

  String _currency(BuildContext context, FamilySummaryEntity? summary) {
    final locale = context.localization;
    return summary?.currencyCode.isNotEmpty == true
        ? summary!.currencyCode
        : locale.currency;
  }
}
