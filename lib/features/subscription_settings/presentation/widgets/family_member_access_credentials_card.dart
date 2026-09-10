import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilyMemberAccessCredentialsCard extends StatelessWidget {
  const FamilyMemberAccessCredentialsCard({
    super.key,
    required this.member,
    this.onEditEmail,
    this.onEditPassword,
  });

  final FamilyMemberAccessEntity member;
  final VoidCallback? onEditEmail;
  final VoidCallback? onEditPassword;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: Spacing.iconMd,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                locale.family_member_access_credentials_section,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Divider(
            color: color.outlineVariant,
            thickness: Spacing.hairline,
            height: Spacing.zero,
          ),
          const SizedBox(height: Spacing.md),
          // Email Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.family_member_access_email_label,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      member.email,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onEditEmail,
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  child: Text(
                    locale.family_member_access_edit,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Divider(
            color: color.outlineVariant,
            thickness: Spacing.hairline,
            height: Spacing.zero,
          ),
          const SizedBox(height: Spacing.md),
          // Password Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.family_member_access_password_label,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      '••••••••',
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onEditPassword,
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  child: Text(
                    locale.family_member_access_edit,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
