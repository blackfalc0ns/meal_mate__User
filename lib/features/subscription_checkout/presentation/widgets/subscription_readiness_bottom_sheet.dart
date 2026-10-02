import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class SubscriptionReadinessBottomSheet extends StatelessWidget {
  const SubscriptionReadinessBottomSheet({
    super.key,
    required this.readiness,
    required this.onItemPressed,
    required this.onAddressPressed,
  });

  final SubscriptionReadinessEntity readiness;
  final ValueChanged<SubscriptionReadinessItemEntity> onItemPressed;
  final VoidCallback onAddressPressed;

  /// Display the readiness bottom sheet and handle navigation flow.
  static Future<void> show({
    required BuildContext context,
    required SubscriptionReadinessEntity readiness,
    required SubscriptionSummaryRequestEntity request,
    required VoidCallback onRequirementFulfilled,
  }) {
    return context.showAppBottomSheet<void>(
      builder: (sheetContext) => SubscriptionReadinessBottomSheet(
        readiness: readiness,
        onAddressPressed: () async {
          Navigator.of(sheetContext).pop();
          final updated = await Navigator.of(context).pushNamed(
            AppRoutes.addressChooseLocation,
            arguments: SubscriptionFlowArgs(request: request),
          );
          if (updated == true && context.mounted) {
            onRequirementFulfilled();
          }
        },
        onItemPressed: (item) async {
          Navigator.of(sheetContext).pop();
          final route = switch (item.actionScreen.toUpperCase()) {
            SubscriptionErrorCodes.actionAddress =>
              AppRoutes.addressChooseLocation,
            SubscriptionErrorCodes.actionDietaryPreferences =>
              AppRoutes.dietaryPreferences,
            SubscriptionErrorCodes.actionAllergies => AppRoutes.addAllergy,
            _ => null,
          };
          if (route == null) return;
          final updated = await Navigator.of(
            context,
          ).pushNamed(route, arguments: SubscriptionFlowArgs(request: request));
          if (updated == true && context.mounted) {
            onRequirementFulfilled();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items = readiness.incompleteItems;
    final hasRestaurantBlock = readiness.hasRestaurantCoverageBlock;
    final hasAddressItem = items.any(
      (item) =>
          item.actionScreen.toUpperCase() ==
          SubscriptionErrorCodes.actionAddress,
    );
    final readinessWarning = readiness.warning(locale.localeName).trim();
    final warning = readinessWarning.isNotEmpty
        ? readinessWarning
        : hasRestaurantBlock
        ? locale.subscription_no_restaurants_for_area
        : '';

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
            if (warning.isNotEmpty) ...[
              Text(
                warning,
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.md),
            ],
            for (final item in items) ...[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                ),
                title: Text(
                  item.title(locale.localeName),
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
                onTap: () => onItemPressed(item),
              ),
            ],
            if (hasRestaurantBlock && !hasAddressItem)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                ),
                title: Text(
                  locale.subscription_change_address,
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
                onTap: onAddressPressed,
              ),
          ],
        ),
      ),
    );
  }
}
