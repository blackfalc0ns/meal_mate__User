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
        final activeMemberId =
            activeState.selectedSummaryMemberId ??
            summary?.selectedMemberId ??
            summary?.selectedMember?.memberId ??
            activeState.members.firstOrNull?.memberId;

        final matchingSchedule = activeState.scheduleForMember(activeMemberId);

        final rawPaymentDate = matchingSchedule?.paymentDate;
        final paymentDate = rawPaymentDate == null
            ? null
            : (AppDatePicker.parseDate(rawPaymentDate) ??
                  DateTime.tryParse(rawPaymentDate));

        final rawFirstDelivery = matchingSchedule?.firstDeliveryDate;
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

        final dateFormatter = DateFormat('d MMMM yyyy', locale.localeName);
        final formattedPaymentDate = paymentDate != null
            ? dateFormatter.format(paymentDate)
            : '--';
        final formattedStartDate = parsedStart != null
            ? dateFormatter.format(parsedStart)
            : '--';
        final formattedEndDate = parsedBackendEnd != null
            ? dateFormatter.format(parsedBackendEnd)
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
                        _pickStartDate(
                          context,
                          activeMemberId,
                          initial,
                          parsedStart,
                        ),
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

  Future<void> _pickStartDate(
    BuildContext context,
    String? activeMemberId,
    DateTime currentStartDate,
    DateTime? backendStartDate,
  ) async {
    final locale = context.localization;
    final today = DateUtils.dateOnly(DateTime.now());
    final earliestDate = backendStartDate ?? today.add(const Duration(days: 1));

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
