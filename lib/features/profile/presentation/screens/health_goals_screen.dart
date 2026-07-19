import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/health_goals_activity_level_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/health_goals_body_data_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/health_goals_goal_summary_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/health_goals_weekly_summary_card.dart';

class HealthGoalsScreen extends StatefulWidget {
  const HealthGoalsScreen({super.key});

  @override
  State<HealthGoalsScreen> createState() => _HealthGoalsScreenState();
}

class _HealthGoalsScreenState extends State<HealthGoalsScreen> {
  var _selectedActivity = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.health_goals_title,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
        onBackPressed: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              child: Column(
                children: [
                  const SizedBox(height: Spacing.healthGoalsHeaderTopGap),
                  const HealthGoalsGoalSummaryCard(),
                  const SizedBox(height: Spacing.healthGoalsSectionGap),
                  const HealthGoalsBodyDataCard(),
                  const SizedBox(height: Spacing.healthGoalsSectionGap),
                  HealthGoalsActivityLevelCard(
                    selectedActivity: _selectedActivity,
                    onActivitySelected: (value) {
                      setState(() => _selectedActivity = value);
                    },
                  ),
                  const SizedBox(height: Spacing.healthGoalsSectionGap),
                  const HealthGoalsWeeklySummaryCard(),
                  const SizedBox(height: Spacing.xxl),
                  AppButton.filled(
                    text: locale.health_goals_save,
                    onPressed: () {},
                    height: Spacing.healthGoalsSaveButtonHeight,
                    borderRadius: Spacing.healthGoalsSaveButtonRadius,
                    color: color.primary,
                    textColor: color.onPrimary,
                    fontSize: FontSize.size13,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
