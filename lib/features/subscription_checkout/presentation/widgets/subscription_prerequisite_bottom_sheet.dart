import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';

class SubscriptionPrerequisiteBottomSheet extends StatelessWidget {
  const SubscriptionPrerequisiteBottomSheet({
    super.key,
    required this.destination,
    required this.onPressed,
  });

  final SubscriptionPrerequisiteDestination destination;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final title = switch (destination) {
      SubscriptionPrerequisiteDestination.address =>
        locale.addresses_choose_location_title,
      SubscriptionPrerequisiteDestination.allergies => locale.add_allergy_title,
      SubscriptionPrerequisiteDestination.dietaryPreferences =>
        locale.profile_dietary_preferences,
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              locale.subscription_flow_profile_incomplete,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.md),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
              ),
              title: Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.primary,
                size: Spacing.iconSm,
              ),
              onTap: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
