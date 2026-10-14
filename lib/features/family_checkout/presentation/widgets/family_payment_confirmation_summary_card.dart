import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_summary_row.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_subscription_toggle_switch.dart';

class FamilyPaymentConfirmationSummaryCard extends StatelessWidget {
  const FamilyPaymentConfirmationSummaryCard({
    super.key,
    required this.member,
    required this.summary,
    this.isSubscribed = true,
    this.onToggleSubscription,
  });

  final FamilyProgramMemberDetailsUiModel member;
  final FamilySelectionSummaryData summary;
  final bool isSubscribed;
  final ValueChanged<bool>? onToggleSubscription;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familySetupMemberCardRadius,
        ),
        border: Border.all(
          color: isSubscribed
              ? color.outlineVariant
              : color.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: member.imageAsset.isNotEmpty
                    ? Image.asset(
                        member.imageAsset,
                        width: Spacing.familyProgramSummaryAvatarSize,
                        height: Spacing.familyProgramSummaryAvatarSize,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildDefaultAvatar(context),
                      )
                    : _buildDefaultAvatar(context),
              ),
              const SizedBox(width: Spacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: isSubscribed
                          ? color.onSurface
                          : color.onSurfaceVariant,
                    ),
                  ),
                  if (member.roleLabel.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.group_rounded,
                          color: isSubscribed
                              ? color.primary
                              : color.onSurfaceVariant,
                          size: Spacing.iconSm,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          member.roleLabel,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: isSubscribed
                                ? color.onSurface
                                : color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    summary.title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: isSubscribed
                          ? color.primary
                          : color.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (onToggleSubscription != null) ...[
            const SizedBox(height: Spacing.sm),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSubscribed
                    ? color.primary.withValues(alpha: 0.05)
                    : color.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(
                  color: isSubscribed
                      ? color.primary.withValues(alpha: 0.25)
                      : color.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  onTap: () => onToggleSubscription!(!isSubscribed),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: Spacing.avatarSm,
                          height: Spacing.avatarSm,
                          decoration: BoxDecoration(
                            color: isSubscribed
                                ? color.primary.withValues(alpha: 0.12)
                                : color.outlineVariant.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSubscribed
                                ? Icons.check_circle_rounded
                                : Icons.pause_circle_filled_rounded,
                            size: Spacing.iconSm,
                            color: isSubscribed
                                ? color.primary
                                : color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                locale.family_include_in_subscription,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: isSubscribed
                                      ? color.onSurface
                                      : color.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: Spacing.xxs),
                              Text(
                                isSubscribed
                                    ? locale.family_member_completed
                                    : locale.family_member_unsubscribed_status,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size9,
                                  color: isSubscribed
                                      ? color.primary
                                      : color.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        IgnorePointer(
                          child: FamilySubscriptionToggleSwitch(
                            value: isSubscribed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: Spacing.sm),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isSubscribed ? 1.0 : 0.45,
            child: Column(
              children: [
                for (final row in summary.rows)
                  FamilyPaymentSummaryRow(row: row),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      width: Spacing.familyProgramSummaryAvatarSize,
      height: Spacing.familyProgramSummaryAvatarSize,
      color: color.primary.withValues(alpha: 0.12),
      child: Icon(
        Icons.person_rounded,
        color: color.primary,
        size: Spacing.iconSm,
      ),
    );
  }
}
