import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_review_meals_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_actions_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_cutoff_banner.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_header_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_instructions_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_macros_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_meal_slot_card.dart';

class FamilyReviewMemberMealsScreen extends StatelessWidget {
  const FamilyReviewMemberMealsScreen({super.key});

  static const _dataSource = FamilyReviewMealsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final data = _dataSource.getContent(locale);

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.family_review_title(data.memberName),
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs / 2),
            Text(
              locale.family_review_subtitle,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
        onBackPressed: () => Navigator.maybePop(context),
      ),
      bottomNavigationBar: FamilyReviewActionsBar(
        memberName: data.memberName,
        onEdit: () {
          context.pushNamed(AppRoutes.familyRestaurants);
        },
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                locale.family_review_success_message,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onPrimary,
                ),
              ),
              backgroundColor: color.primary,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.maybePop(context);
        },
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FamilyReviewHeaderCard(
                memberName: data.memberName,
                avatarAsset: data.avatarAsset,
                statusLabel: data.statusLabel,
                dateLabel: data.dateLabel,
                goalLabel: data.goalLabel,
              ),
              const SizedBox(height: Spacing.base),
              Row(
                children: [
                  Icon(
                    Icons.restaurant_menu_rounded,
                    size: Spacing.iconMd,
                    color: color.primary,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    locale.family_review_selected_meals_section,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              for (final slot in data.slots)
                FamilyReviewMealSlotCard(
                  slot: slot,
                  onEdit: () {
                    context.pushNamed(AppRoutes.familyMealSelection);
                  },
                ),
              const SizedBox(height: Spacing.base),
              FamilyReviewMacrosCard(nutrition: data.nutrition),
              const SizedBox(height: Spacing.base),
              FamilyReviewInstructionsCard(
                instructions: data.instructions,
                note: data.instructionsNote,
              ),
              const SizedBox(height: Spacing.base),
              FamilyReviewCutoffBanner(
                title: data.cutoffTitle,
                description: data.cutoffDescription,
                remainingTime: data.cutoffRemainingTime,
                disclaimer: data.cutoffDisclaimer,
              ),
              const SizedBox(height: Spacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
