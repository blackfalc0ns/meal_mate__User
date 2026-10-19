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

class FamilyMemberDetailProgramCard extends StatelessWidget {
  const FamilyMemberDetailProgramCard({super.key, required this.member});

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
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  member.programImageAsset,
                  width: Spacing.familyMemberDetailProgramImageWidth,
                  height: Spacing.familyMemberDetailProgramImageHeight,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: Spacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      member.programName,
                      locale: Locale(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size15,
                        color: color.primary,
                      ),
                    ),
                    if (member.programSubtitle.isNotEmpty) ...[
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        member.programSubtitle,
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
          FamilyMemberDetailActionButton(
            label: member.changeProgramLabel,
            icon: Icons.sync_alt_rounded,
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.familyProgramSetup,
              arguments: member.memberId,
            ),
          ),
        ],
      ),
    );
  }
}
