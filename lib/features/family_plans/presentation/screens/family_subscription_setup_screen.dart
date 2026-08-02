import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_field.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_form_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_members_row.dart';

class FamilySubscriptionSetupScreen extends StatelessWidget {
  const FamilySubscriptionSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        showBackButton: true,
        titleWidget: Column(
          children: [
            Text(
              locale.family_setup_title,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurface,
              ),
            ),
            Text(
              locale.family_setup_subtitle,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size8,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / Spacing.familySetupDesignWidth;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.familySetupHorizontalPadding * scale,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: Spacing.xxl * scale),
                      FamilySetupField(
                        label: locale.family_name,
                        hint: locale.family_name_hint,
                        icon: Icons.groups_2_rounded,
                      ),
                      SizedBox(height: Spacing.familySetupSectionGap * scale),
                      FamilySetupMembersRow(
                        members: [
                          FamilySetupMemberData(
                            name: locale.family_member_ahmed,
                            imageAsset: AssetsFake.familyMemberAhmed,
                          ),
                          FamilySetupMemberData(
                            name: locale.family_member_sarah,
                            imageAsset: AssetsFake.familyMemberSarah,
                          ),
                        ],
                      ),
                      SizedBox(height: Spacing.familySetupSectionGap * scale),
                      const FamilySetupFormCard(),
                      SizedBox(height: Spacing.familySetupSectionGap * scale),
                      const FamilySetupActions(),
                      const SizedBox(height: Spacing.xl),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
