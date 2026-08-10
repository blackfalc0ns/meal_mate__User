import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_action_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_header_icon.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_section_card.dart';

class FamilyMemberDetailProgramCard extends StatelessWidget {
  const FamilyMemberDetailProgramCard({super.key, required this.member});

  final FamilyMemberDetailEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return FamilyMemberDetailSectionCard(
      height: Spacing.familyMemberDetailStandardCardHeight + Spacing.xxl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FamilyMemberDetailHeaderIcon(
                icon: Icons.restaurant_rounded,
              ),
              const SizedBox(width: Spacing.sm),

              Text(
                member.programTitle,
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
          Center(
            child: ClipOval(
              child: Image.asset(
                member.programImageAsset,
                width: Spacing.familyMemberDetailProgramImageWidth,
                height: Spacing.familyMemberDetailProgramImageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            member.programName,
            locale: Locale(locale.localeName),
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size15,
              color: color.primary,
            ),
          ),
          const Spacer(),
          FamilyMemberDetailActionButton(label: member.changeProgramLabel),
        ],
      ),
    );
  }
}
