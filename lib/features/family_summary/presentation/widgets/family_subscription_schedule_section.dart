import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_date_picker.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_date_card.dart';

class FamilySubscriptionScheduleSection extends StatelessWidget {
  const FamilySubscriptionScheduleSection({super.key, required this.state});

  final FamilyCheckoutState state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyCheckoutViewModel, FamilyCheckoutState>(
      buildWhen: (prev, curr) {
        final prevMember = prev.activeMemberId;
        final currMember = curr.activeMemberId;
        return prevMember != currMember ||
            prev.scheduleForMember(prevMember) !=
                curr.scheduleForMember(currMember) ||
            prev.summaryMember(prevMember) != curr.summaryMember(currMember) ||
            prev.flowMember(prevMember) != curr.flowMember(currMember);
      },
      builder: (context, activeState) {
        final color = context.colorScheme;
        final locale = context.localization;

        final summary = activeState.summary;
        final selectedMemberSummary = summary?.selectedMember;
        final activeMemberId =
            selectedMemberSummary?.memberId ??
            activeState.selectedSummaryMemberId ??
            summary?.selectedMemberId ??
            activeState.members.firstOrNull?.memberId;

        final matchingFlowMember = activeState.flowMember(activeMemberId);
        final matchingSchedule = activeState.scheduleForMember(activeMemberId);

        final rawPaymentDate = matchingSchedule?.paymentDate;
        final paymentDate =
            (rawPaymentDate != null
                ? (AppDatePicker.parseDate(rawPaymentDate) ??
                      DateTime.tryParse(rawPaymentDate))
                : null) ??
            DateTime.now();

        final rawFirstDelivery =
            matchingSchedule?.firstDeliveryDate ??
            selectedMemberSummary?.startDate ??
            matchingFlowMember?.startDate;
        final parsedStart =
            AppDatePicker.parseDate(rawFirstDelivery) ??
            (rawFirstDelivery != null
                ? DateTime.tryParse(rawFirstDelivery)
                : null);

        final rawEndDate = matchingSchedule?.endDate;
        final parsedBackendEnd = rawEndDate != null
            ? (AppDatePicker.parseDate(rawEndDate) ??
                  DateTime.tryParse(rawEndDate))
            : null;

        final durationDays =
            matchingSchedule?.deliveryDaysCount != null &&
                matchingSchedule!.deliveryDaysCount > 0
            ? matchingSchedule.deliveryDaysCount
            : (selectedMemberSummary?.durationDays ??
                  matchingFlowMember?.durationDays);
        final includeFriday =
            selectedMemberSummary?.includeFriday ??
            matchingFlowMember?.includeFriday ??
            false;

        final DateTime? calculatedEnd =
            (parsedStart != null && durationDays != null && durationDays > 0)
            ? _calculateEndDate(parsedStart, durationDays, includeFriday)
            : null;
        final DateTime? effectiveEnd = parsedBackendEnd ?? calculatedEnd;

        final dateFormatter = DateFormat('d MMMM yyyy', locale.localeName);
        final formattedPaymentDate = dateFormatter.format(paymentDate);
        final formattedStartDate = parsedStart != null
            ? dateFormatter.format(parsedStart)
            : '--';
        final formattedEndDate = effectiveEnd != null
            ? dateFormatter.format(effectiveEnd)
            : '--';

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
                  child: FamilyDateCard(
                    title: locale.family_payment_date,
                    dateText: formattedPaymentDate,
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: FamilyDateCard(
                    title: locale.family_start_date,
                    dateText: formattedStartDate,
                    isEditable: true,
                    onTap: () {
                      final initial =
                          parsedStart ??
                          DateUtils.dateOnly(
                            DateTime.now().add(const Duration(days: 2)),
                          );
                      unawaited(
                        _pickStartDate(context, activeMemberId, initial),
                      );
                    },
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: FamilyDateCard(
                    title: locale.family_end_date,
                    dateText: formattedEndDate,
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
        UpdateMemberStartDateEvent(memberId: activeMemberId, startDate: picked),
      );
    }
  }
}

typedef FamilyPaymentScheduleSection = FamilySubscriptionScheduleSection;
