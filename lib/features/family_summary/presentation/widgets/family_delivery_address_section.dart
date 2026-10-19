import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';

class FamilyDeliveryAddressSection extends StatelessWidget {
  const FamilyDeliveryAddressSection({super.key, required this.state});

  final FamilyCheckoutState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocBuilder<FamilyCheckoutViewModel, FamilyCheckoutState>(
      buildWhen: (previous, current) {
        final prevId =
            previous.selectedSummaryMemberId ??
            previous.summary?.selectedMemberId ??
            previous.members.firstOrNull?.memberId;
        final currId =
            current.selectedSummaryMemberId ??
            current.summary?.selectedMemberId ??
            current.members.firstOrNull?.memberId;
        final prevAddress =
            previous.scheduleForMember(prevId)?.addressLine ??
            previous.summary?.selectedMember?.addressLine ??
            previous.flowMember(prevId)?.deliveryAddress?.addressLine;
        final currAddress =
            current.scheduleForMember(currId)?.addressLine ??
            current.summary?.selectedMember?.addressLine ??
            current.flowMember(currId)?.deliveryAddress?.addressLine;
        return prevId != currId || prevAddress != currAddress;
      },
      builder: (context, activeState) {
        final summary = activeState.summary;
        final selectedMemberSummary = summary?.selectedMember;
        final activeMemberId =
            activeState.selectedSummaryMemberId ??
            summary?.selectedMemberId ??
            activeState.members.firstOrNull?.memberId;

        final matchingFlowMember = activeState.flowMember(activeMemberId);
        final matchingSchedule = activeState.scheduleForMember(activeMemberId);

        final rawAddress =
            matchingSchedule?.addressLine ??
            selectedMemberSummary?.addressLine ??
            matchingFlowMember?.deliveryAddress?.addressLine;

        final displayAddress =
            (rawAddress != null && rawAddress.trim().isNotEmpty)
            ? rawAddress.trim()
            : '--';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.family_address_select,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Container(
              padding: const EdgeInsets.all(Spacing.base),
              decoration: BoxDecoration(
                color: color.surface,
                border: Border.all(
                  color: color.outlineVariant,
                  width: Spacing.border,
                ),
                borderRadius: BorderRadius.circular(Spacing.radiusLg),
              ),
              child: Row(
                children: [
                  Container(
                    width: Spacing.avatarSm,
                    height: Spacing.avatarSm,
                    decoration: BoxDecoration(
                      color: color.primaryContainer,
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.location_on_rounded,
                      color: color.primary,
                      size: Spacing.iconSm,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Text(
                      displayAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
