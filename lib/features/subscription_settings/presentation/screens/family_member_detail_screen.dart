import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_subscription_settings_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_package_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_profile_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_program_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_progress_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_shortcut_bar.dart';

class FamilyMemberDetailScreen extends StatelessWidget {
  const FamilyMemberDetailScreen({super.key});

  static const _dataSource = FamilySubscriptionSettingsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final member = _dataSource.getMemberDetail();

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: Text(
          member.title,
          locale: Locale(locale.localeName),
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size15,
            color: color.onSurface,
          ),
        ),
        onBackPressed: () => Navigator.maybePop(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.familyMemberDetailHorizontalPadding,
          end: Spacing.familyMemberDetailHorizontalPadding,
          top: Spacing.familyMemberDetailCardGap,
          bottom: Spacing.xl,
        ),
        child: Column(
          children: [
            FamilyMemberDetailProfileCard(member: member),
            const SizedBox(height: Spacing.familyMemberDetailCardGap),
            FamilyMemberDetailProgramCard(member: member),
            const SizedBox(height: Spacing.familyMemberDetailCardGap),
            FamilyMemberDetailPackageCard(member: member),
            const SizedBox(height: Spacing.familyMemberDetailCardGap),
            FamilyMemberDetailProgressCard(member: member),
            const SizedBox(height: Spacing.familyMemberDetailCardGap),
            FamilyMemberDetailShortcutBar(shortcuts: member.shortcuts),
          ],
        ),
      ),
    );
  }
}
