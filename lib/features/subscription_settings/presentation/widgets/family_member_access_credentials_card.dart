import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberAccessCredentialsCard extends StatelessWidget {
  const FamilyMemberAccessCredentialsCard({
    super.key,
    this.identifier,
    this.onEditIdentifier,
    this.onEditPassword,
  });

  final String? identifier;
  final VoidCallback? onEditIdentifier;
  final VoidCallback? onEditPassword;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final displayIdentifier = identifier?.trim().isNotEmpty == true
        ? identifier!
        : locale.family_member_no_plan;

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
          Text(
            locale.family_member_access_credentials_section,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Divider(
            color: color.outlineVariant.withValues(alpha: 0.5),
            thickness: Spacing.hairline,
            height: Spacing.md,
          ),
          // Identifier Row (Phone / Email)
          Row(
            children: [
              Text(
                locale.family_member_access_phone_label,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                displayIdentifier,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(width: Spacing.md),
              InkWell(
                onTap: onEditIdentifier,
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: Spacing.xxs,
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
          Divider(
            color: color.outlineVariant.withValues(alpha: 0.5),
            thickness: Spacing.hairline,
            height: Spacing.md,
          ),
          // Password Row
          Row(
            children: [
              Text(
                locale.family_member_access_password_label,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                '••••••••',
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(width: Spacing.md),
              InkWell(
                onTap: onEditPassword,
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: Spacing.xxs,
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
