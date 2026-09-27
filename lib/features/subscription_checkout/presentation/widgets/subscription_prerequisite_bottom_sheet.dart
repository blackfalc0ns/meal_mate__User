import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';

class SubscriptionPrerequisiteBottomSheet extends StatelessWidget {
  const SubscriptionPrerequisiteBottomSheet({
    super.key,
    this.destination,
    this.onPressed,
    this.destinations,
    this.onDestinationSelected,
  }) : assert(
         (destinations != null && onDestinationSelected != null) ||
             (destination != null && onPressed != null),
         'Either destinations with onDestinationSelected or destination with onPressed must be provided',
       );

  final SubscriptionPrerequisiteDestination? destination;
  final VoidCallback? onPressed;
  final List<SubscriptionPrerequisiteDestination>? destinations;
  final ValueChanged<SubscriptionPrerequisiteDestination>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items =
        destinations ??
        (destination != null
            ? [destination!]
            : const <SubscriptionPrerequisiteDestination>[]);

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
            for (var i = 0; i < items.length; i++) ...[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                ),
                title: Text(
                  _titleForDestination(items[i], locale),
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
                onTap: () {
                  if (onDestinationSelected != null) {
                    onDestinationSelected!(items[i]);
                  } else if (onPressed != null) {
                    onPressed!();
                  }
                },
              ),
              if (i < items.length - 1)
                Divider(
                  height: Spacing.border,
                  thickness: Spacing.border,
                  color: color.outlineVariant,
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _titleForDestination(
    SubscriptionPrerequisiteDestination destination,
    AppLocalizations locale,
  ) {
    return switch (destination) {
      SubscriptionPrerequisiteDestination.address =>
        locale.addresses_choose_location_title,
      SubscriptionPrerequisiteDestination.allergies => locale.add_allergy_title,
      SubscriptionPrerequisiteDestination.dietaryPreferences =>
        locale.profile_dietary_preferences,
    };
  }
}
