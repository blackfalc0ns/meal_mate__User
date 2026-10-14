import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_date_picker.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_view_model.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_schedule_card.dart';

class FamilyPaymentScheduleSection extends StatelessWidget {
  const FamilyPaymentScheduleSection({
    super.key,
    required this.state,
  });

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final summary = state.summary;
    final selectedMemberSummary = summary?.selectedMember;
    final activeMemberId = selectedMemberSummary?.memberId ??
        state.selectedSummaryMemberId ??
        summary?.selectedMemberId ??
        state.members.firstOrNull?.memberId;

    final matchingFlowMember = state.members
        .where((m) => m.memberId == activeMemberId)
        .firstOrNull;

    final matchingSchedule = summary?.memberSchedules
        .where((s) => s.memberId == activeMemberId)
        .firstOrNull;

    final rawPaymentDate = matchingSchedule?.paymentDate;
    final paymentDate = (rawPaymentDate != null
            ? (AppDatePicker.parseDate(rawPaymentDate) ??
                DateTime.tryParse(rawPaymentDate))
            : null) ??
        DateTime.now();

    final rawFirstDelivery = matchingSchedule?.firstDeliveryDate ??
        selectedMemberSummary?.startDate ??
        matchingFlowMember?.startDate;
    final parsedStart = AppDatePicker.parseDate(rawFirstDelivery) ??
        (rawFirstDelivery != null ? DateTime.tryParse(rawFirstDelivery) : null);
    final startDate = parsedStart ??
        DateUtils.dateOnly(DateTime.now().add(const Duration(days: 2)));

    final rawEndDate = matchingSchedule?.endDate;
    final parsedBackendEnd = rawEndDate != null
        ? (AppDatePicker.parseDate(rawEndDate) ??
            DateTime.tryParse(rawEndDate))
        : null;

    final durationDays = matchingSchedule?.deliveryDaysCount != null &&
            matchingSchedule!.deliveryDaysCount > 0
        ? matchingSchedule.deliveryDaysCount
        : (selectedMemberSummary?.durationDays ??
            matchingFlowMember?.durationDays ??
            20);
    final includeFriday = selectedMemberSummary?.includeFriday ??
        matchingFlowMember?.includeFriday ??
        false;

    final endDate = parsedBackendEnd ??
        _calculateEndDate(startDate, durationDays, includeFriday);

    final dateFormatter = DateFormat('d MMMM yyyy', locale.localeName);
    final formattedPaymentDate = dateFormatter.format(paymentDate);
    final formattedStartDate = dateFormatter.format(startDate);
    final formattedEndDate = dateFormatter.format(endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.family_schedule_section_title,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Row(
          children: [
            Expanded(
              child: FamilyPaymentScheduleCard(
                title: locale.family_payment_date,
                dateText: formattedPaymentDate,
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Expanded(
              child: FamilyPaymentScheduleCard(
                title: locale.family_start_date,
                dateText: formattedStartDate,
                isEditable: true,
                onTap: () => _pickStartDate(context, activeMemberId, startDate),
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Expanded(
              child: FamilyPaymentScheduleCard(
                title: locale.family_end_date,
                dateText: formattedEndDate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  DateTime _calculateEndDate(
    DateTime start,
    int durationDays,
    bool includeFriday,
  ) {
    if (durationDays <= 1) return start;
    DateTime current = start;
    int remainingDeliveryDays = durationDays - 1;
    while (remainingDeliveryDays > 0) {
      current = current.add(const Duration(days: 1));
      if (!includeFriday && current.weekday == DateTime.friday) {
        continue;
      }
      remainingDeliveryDays--;
    }
    return current;
  }

  Future<void> _pickStartDate(
    BuildContext context,
    String? activeMemberId,
    DateTime currentStartDate,
  ) async {
    final locale = context.localization;
    final today = DateUtils.dateOnly(DateTime.now());
    final earliestDate = today.add(const Duration(days: 1));

    final picked = await AppDatePicker.showFormatted(
      context: context,
      initialDate: currentStartDate.isBefore(earliestDate)
          ? earliestDate
          : currentStartDate,
      firstDate: earliestDate,
      helpText: locale.family_start_date_picker_help,
    );

    if (picked != null && activeMemberId != null && context.mounted) {
      context.read<FamilyCheckoutViewModel>().doIntent(
            UpdateMemberStartDateEvent(
              memberId: activeMemberId,
              startDate: picked,
            ),
          );
    }
  }
}
