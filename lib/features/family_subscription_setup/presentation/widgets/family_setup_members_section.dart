import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_add_member_dialog.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_member_tile.dart';

class FamilySetupMembersSection extends StatelessWidget {
  const FamilySetupMembersSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final members = state.members;
    final maxMembers = state.maxMembers;
    final isMaxReached = members.length >= maxMembers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.family_members_count_label,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isMaxReached
                    ? color.error.withValues(alpha: 0.1)
                    : color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
              child: Text(
                locale.family_members_count_indicator(
                  members.length,
                  maxMembers,
                ),
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: isMaxReached ? color.error : color.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        ...members.map(
          (member) => FamilySetupMemberTile(
            member: member,
            onEdit: () => _openEditMemberDialog(context, member),
            onDelete: () => _confirmDeleteMember(context, member),
          ),
        ),
        if (!isMaxReached) ...[
          const SizedBox(height: Spacing.xs),
          OutlinedButton.icon(
            onPressed: () => _openAddMemberDialog(context),
            icon: Icon(Icons.add_circle_outline_rounded, color: color.primary),
            label: Text(
              locale.family_add_member,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: BorderSide(color: color.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: Spacing.xs),
          Text(
            locale.family_members_max_reached,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  void _openAddMemberDialog(BuildContext context) {
    FamilyAddMemberDialog.show(
      context: context,
      relationships: state.relationships,
      addresses: state.addresses,
      onSubmit:
          ({
            required String phone,
            required String displayName,
            String? occupation,
            required String relationshipCode,
            required int gender,
            required int ageYears,
            String? deliveryAddressId,
          }) {
            context.read<FamilySubscriptionSetupViewModel>().doIntent(
              AddFamilyMemberEvent(
                phone: phone,
                displayName: displayName,
                occupation: occupation,
                relationshipCode: relationshipCode,
                gender: gender,
                ageYears: ageYears,
                deliveryAddressId: deliveryAddressId,
              ),
            );
          },
    );
  }

  void _openEditMemberDialog(BuildContext context, FamilyMemberEntity member) {
    FamilyAddMemberDialog.show(
      context: context,
      member: member,
      relationships: state.relationships,
      addresses: state.addresses,
      onSubmit:
          ({
            required String phone,
            required String displayName,
            String? occupation,
            required String relationshipCode,
            required int gender,
            required int ageYears,
            String? deliveryAddressId,
          }) {
            context.read<FamilySubscriptionSetupViewModel>().doIntent(
              UpdateFamilyMemberEvent(
                memberId: member.memberId,
                phone: phone,
                displayName: displayName,
                occupation: occupation,
                relationshipCode: relationshipCode,
                gender: gender,
                ageYears: ageYears,
                deliveryAddressId: deliveryAddressId,
              ),
            );
          },
    );
  }

  Future<void> _confirmDeleteMember(
    BuildContext context,
    FamilyMemberEntity member,
  ) async {
    final locale = context.localization;
    final color = context.colorScheme;
    final confirmed = await context.showAppCustomDialog<bool>(
      title: locale.family_delete_member_confirmation_title,
      message: locale.family_delete_member_confirmation_message,
      confirmText: locale.family_member_access_remove_label,
      cancelText: locale.family_cancel,
      icon: Icons.delete_outline_rounded,
      iconColor: color.error,
      confirmTextColor: color.error,
      onConfirm: () => true,
      onCancel: () => false,
    );

    if (!context.mounted || confirmed != true) return;
    context.read<FamilySubscriptionSetupViewModel>().doIntent(
      DeleteFamilyMemberEvent(member.memberId),
    );
  }
}
