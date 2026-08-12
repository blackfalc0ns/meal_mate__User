import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_section_card.dart';

class FamilyMemberDetailProfileCard extends StatelessWidget {
  const FamilyMemberDetailProfileCard({super.key, required this.member});

  final FamilyMemberDetailEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return FamilyMemberDetailSectionCard(
      height: Spacing.familyMemberDetailProfileHeight,
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
                ),
              ),
            ],
          ),

          SizedBox(width: Spacing.lg),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                member.name,

                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size18,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: Spacing.iconSm,
                    color: color.primary,
                  ),
                  const SizedBox(width: Spacing.sm),

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
              const SizedBox(height: Spacing.xs),
              Container(
                height: Spacing.familyMemberDetailChipHeight,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                decoration: BoxDecoration(
                  color: color.primaryContainer.withValues(alpha: 0.45),
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
                    const SizedBox(width: Spacing.sm),

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
              const SizedBox(height: Spacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    member.roleLabel,
                    locale: Locale(locale.localeName),
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  // const SizedBox(width: Spacing.sm),
                  // Icon(
                  //   Icons.admin_panel_settings_rounded,
                  //   size: Spacing.iconSm,
                  //   color: color.primary,
                  // ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Icon(
            Icons.chevron_right_rounded,
            size: Spacing.iconLg,
            color: color.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
