import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/shared/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_section_card.dart';

class FamilyMemberDetailProfileCard extends StatelessWidget {
  const FamilyMemberDetailProfileCard({super.key, required this.member});

  final FamilyMemberDetailEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final canNavigate = member.canManageAccess && member.memberId.isNotEmpty;
    return InkWell(
      onTap: canNavigate
          ? () => context.pushNamed(
              AppRoutes.familyMemberAccess,
              arguments: (member.memberId, member.isManager, member.name),
            )
          : null,
      borderRadius: BorderRadius.circular(Spacing.familyMemberDetailCardRadius),
      child: FamilyMemberDetailSectionCard(
        height: Spacing.familyMemberDetailProfileHeight,
        backgroundColor: color.primaryContainer.withValues(alpha: 0.35),
        borderColor: color.primaryContainer.withValues(alpha: 0.5),
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                ClipOval(
                  child: Image.asset(
                    member.imageAsset,
                    width: Spacing.familyMemberDetailAvatarSize,
                    height: Spacing.familyMemberDetailAvatarSize,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: Spacing.familyMemberDetailAvatarStatusSize,
                  height: Spacing.familyMemberDetailAvatarStatusSize,
                  decoration: BoxDecoration(
                    color: color.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.surface,
                      width: Spacing.xxs,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size18,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Container(
                    height: Spacing.familyMemberDetailChipHeight,
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                    decoration: BoxDecoration(
                      color: color.primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(
                        Spacing.familyMemberDetailChipRadius,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: Spacing.familyMemberDetailStatusDotSize,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          member.statusLabel,
                          locale: Locale(locale.localeName),
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (member.ageLabel.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          member.ageLabel,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (member.roleLabel.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          member.roleLabel,
                          locale: Locale(locale.localeName),
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (canNavigate) ...[
              Container(
                width: Spacing.xxl,
                height: Spacing.xxl,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.08),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.xxs),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: Spacing.iconMd,
                  color: color.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
