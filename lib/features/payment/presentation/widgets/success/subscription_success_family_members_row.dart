import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_card.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';

/// Horizontal strip displaying family members on the payment success screen.
/// Uses the exact [FamilyProgramMemberCard] matching the family subscription flow.
class SubscriptionSuccessFamilyMembersRow extends StatelessWidget {
  const SubscriptionSuccessFamilyMembersRow({
    super.key,
    required this.members,
    required this.selectedIndex,
    required this.onMemberSelected,
  });

  final List<PaymentSuccessMemberArgs> members;
  final int selectedIndex;
  final ValueChanged<int> onMemberSelected;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    final locale = context.localization;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Row(
          children: [
            for (int i = 0; i < members.length; i++) ...[
              if (i > 0) const SizedBox(width: Spacing.familyProgramMemberGap),
              FamilyProgramMemberCard(
                member: FamilyProgramMemberUiModel(
                  name: members[i].displayName,
                  imageAsset: resolveFamilyMemberAvatar(members[i].gender, i),
                  status: locale.family_member_completed,
                  isSelected: selectedIndex == i,
                  isInProgress: false,
                ),
                onTap: () => onMemberSelected(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
