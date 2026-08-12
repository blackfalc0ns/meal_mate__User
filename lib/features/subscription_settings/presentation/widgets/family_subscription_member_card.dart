import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilySubscriptionMemberCard extends StatelessWidget {
  const FamilySubscriptionMemberCard({super.key, required this.member});

  final FamilySubscriptionMemberEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.familyManageMemberCardHeight,
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadiusDirectional.circular(11.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              member.imageAsset,
              width: Spacing.familyManageMemberAvatarSize,
              height: Spacing.familyManageMemberAvatarSize,
              fit: BoxFit.cover,
            ),
          ),

          Text(
            member.name,
            locale: Locale(locale.localeName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: 10.89,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Spacing.xss,
                height: Spacing.xss,
                decoration: BoxDecoration(
                  color: member.isComplete
                      ? color.primary
                      : color.onSurfaceVariant,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                member.statusLabel,
                locale: Locale(locale.localeName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: 9.1,
                  color: member.isComplete
                      ? color.primary
                      : color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
