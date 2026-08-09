import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_subscription_settings_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_meals_status_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_members_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_plan_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_quick_access_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_warning_card.dart';

class FamilySubscriptionSettingsScreen extends StatelessWidget {
  const FamilySubscriptionSettingsScreen({super.key});

  static const _dataSource = FamilySubscriptionSettingsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final settings = _dataSource.getSettings();

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.family_manage_title,
        titleFontSize: FontSize.size14,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familyManageHorizontalPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: Spacing.md),
              FamilySubscriptionPlanCard(settings: settings),
              const SizedBox(height: Spacing.xl),
              FamilySubscriptionMembersSection(members: settings.members),
              const SizedBox(height: Spacing.xl),
              FamilySubscriptionQuickAccessSection(
                actions: settings.quickActions,
              ),
              const SizedBox(height: Spacing.xl),
              FamilySubscriptionMealsStatusCard(
                statuses: settings.mealStatuses,
              ),
              const SizedBox(height: Spacing.xl),
              FamilySubscriptionWarningCard(settings: settings),
              const SizedBox(height: Spacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
