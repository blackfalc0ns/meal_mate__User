import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/shared/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_action_button.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_header_icon.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_section_card.dart';

class FamilyMemberDetailPackageCard extends StatelessWidget {
  const FamilyMemberDetailPackageCard({
    super.key,
    required this.member,
    this.onAction,
    this.showAction = true,
  });

  final FamilyMemberDetailEntity member;
  final VoidCallback? onAction;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return FamilyMemberDetailSectionCard(
      height: Spacing.familyMemberDetailStandardCardHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FamilyMemberDetailHeaderIcon(
                icon: Icons.inventory_2_rounded,
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                member.packageTitle,
                locale: Locale(locale.localeName),
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              if (member.packageImageAsset.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  child: Image.asset(
                    member.packageImageAsset,
                    width: Spacing.familyMemberDetailProgramImageWidth,
                    height: Spacing.familyMemberDetailProgramImageHeight,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: Spacing.base),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      member.remainingDaysLabel,
                      locale: Locale(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size15,
                        color: color.primary,
                      ),
                    ),
                    if (member.packageDescription.isNotEmpty) ...[
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        member.packageDescription,
                        locale: Locale(locale.localeName),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (showAction)
            FamilyMemberDetailActionButton(
              label: member.editPackageLabel,
              icon: Icons.open_in_new_rounded,
              onPressed:
                  onAction ??
                  () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.familyPackageDaysSetup),
            ),
        ],
      ),
    );
  }
}
