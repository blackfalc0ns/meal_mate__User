import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_date_picker.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/server_start_date_picker.dart';
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
                      unawaited(
                        _pickStartDate(
                          context,
                          activeMemberId,
                          rawFirstDelivery,
                          activeState
                                  .flowMember(activeMemberId)
                                  ?.includeFriday ??
                              (activeState.summary?.selectedMember?.memberId ==
                                      activeMemberId
                                  ? activeState
                                        .summary
                                        ?.selectedMember
                                        ?.includeFriday
                                  : null) ??
                              false,
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
    String? currentStartDate,
    bool includeFriday,
  ) async {
    final picked = await ServerStartDatePicker.show(
      context: context,
      initialDate: currentStartDate,
      includeFriday: includeFriday,
    );

    if (picked != null && activeMemberId != null && context.mounted) {
      context.read<FamilyCheckoutViewModel>().doIntent(
        UpdateMemberStartDateEvent(memberId: activeMemberId, startDate: picked),
      );
    }
  }
}

typedef FamilyPaymentScheduleSection = FamilySubscriptionScheduleSection;
