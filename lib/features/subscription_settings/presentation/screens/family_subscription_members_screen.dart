import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_subscription_settings_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_members_add_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_members_list_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_members_search_field.dart';

class FamilySubscriptionMembersScreen extends StatelessWidget {
  const FamilySubscriptionMembersScreen({super.key});

  static const _dataSource = FamilySubscriptionSettingsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final membersPage = _dataSource.getMembersPage();

    return Scaffold(
      backgroundColor: color.surface,
      extendBody: true,
      appBar: CustomAppBar(
        title: locale.family_members_title,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.familyMembersHorizontalPadding,
            end: Spacing.familyMembersHorizontalPadding,
            bottom:
                Spacing.bottomNavHeight + Spacing.familyMembersBottomNavTopGap,
          ),
          child: Column(
            children: [
              const SizedBox(height: Spacing.familyMembersSearchTopGap),
              const FamilyMembersSearchField(),
              const SizedBox(height: Spacing.familyMembersListTopGap),
              for (int index = 0; index < membersPage.members.length; index++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: index == membersPage.members.length - 1
                        ? Spacing.zero
                        : Spacing.familyMembersCardGap,
                  ),
                  child: FamilyMembersListCard(
                    member: membersPage.members[index],
                  ),
                ),
              const SizedBox(height: Spacing.familyMembersAddButtonTopGap),
              const FamilyMembersAddButton(),
            ],
          ),
        ),
      ),
    );
  }
}
