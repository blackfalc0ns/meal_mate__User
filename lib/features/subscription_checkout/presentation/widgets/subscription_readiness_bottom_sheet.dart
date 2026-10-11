import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
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
          final action = item.actionScreen.toUpperCase();
          final endpoint = item.endpoint?.toLowerCase() ?? '';
          final route = switch (action) {
            SubscriptionErrorCodes.actionAddress =>
              AppRoutes.addressChooseLocation,
            SubscriptionErrorCodes.actionAllergies => AppRoutes.addAllergy,
            SubscriptionErrorCodes.actionDietaryPreferences =>
              AppRoutes.dietaryPreferences,
            _ =>
              endpoint.contains('address')
                  ? AppRoutes.addressChooseLocation
                  : endpoint.contains('allerg')
                  ? AppRoutes.addAllergy
                  : (endpoint.contains('preference') ||
                        endpoint.contains('diet'))
                  ? AppRoutes.dietaryPreferences
                  : null,
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
    final items = [...readiness.incompleteItems]
      ..sort((a, b) {
        int order(String step, String? endpoint) {
          final s = step.toUpperCase();
          final ep = (endpoint ?? '').toLowerCase();
          if (s == SubscriptionErrorCodes.actionAddress ||
              s.contains('ADDRESS') ||
              ep.contains('address')) {
            return 1;
          }
          if (s == SubscriptionErrorCodes.actionAllergies ||
              s.contains('ALLERG') ||
              ep.contains('allerg')) {
            return 2;
          }
          if (s == SubscriptionErrorCodes.actionDietaryPreferences ||
              s.contains('DIET') ||
              s.contains('PREFER') ||
              ep.contains('preference') ||
              ep.contains('diet')) {
            return 3;
          }
          return 4;
        }

        return order(
          a.actionScreen,
          a.endpoint,
        ).compareTo(order(b.actionScreen, b.endpoint));
      });
    final hasRestaurantBlock = readiness.hasRestaurantCoverageBlock;

    final hasAddressItem = items.any(
      (item) =>
          item.actionScreen.toUpperCase() ==
          SubscriptionErrorCodes.actionAddress,
    );
    final readinessWarning = readiness.warning(locale.localeName).trim();
    final blockReason = readiness.checkoutBlockReason?.trim();
    final mappedBlockReason = (blockReason != null && blockReason.isNotEmpty)
        ? mapFailureMessage(context, blockReason)
        : '';
    final warning = readinessWarning.isNotEmpty
        ? readinessWarning
        : mappedBlockReason.isNotEmpty
        ? mappedBlockReason
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
