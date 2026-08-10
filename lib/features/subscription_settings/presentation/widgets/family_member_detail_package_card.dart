import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_action_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_header_icon.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_section_card.dart';

class FamilyMemberDetailPackageCard extends StatelessWidget {
  const FamilyMemberDetailPackageCard({super.key, required this.member});

  final FamilyMemberDetailEntity member;

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
          Text(
            member.remainingDaysLabel,
            locale: Locale(locale.localeName),
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size15,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            member.packageDescription,
            locale: Locale(locale.localeName),
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          FamilyMemberDetailActionButton(label: member.editPackageLabel),
        ],
      ),
    );
  }
}
