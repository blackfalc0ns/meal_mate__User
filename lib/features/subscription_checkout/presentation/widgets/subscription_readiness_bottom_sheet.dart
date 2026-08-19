import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class SubscriptionReadinessBottomSheet extends StatelessWidget {
  const SubscriptionReadinessBottomSheet({
    super.key,
    required this.readiness,
    required this.onItemPressed,
  });

  final SubscriptionReadinessEntity readiness;
  final ValueChanged<SubscriptionReadinessItemEntity> onItemPressed;

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
        onItemPressed: (item) async {
          Navigator.of(sheetContext).pop();
          final route = switch (item.actionScreen.toUpperCase()) {
            'ADDRESS' => AppRoutes.addressChooseLocation,
            'DIETARY_PREFERENCES' => AppRoutes.dietaryPreferences,
            'ALLERGIES' => AppRoutes.addAllergy,
            _ => null,
          };
          if (route == null) return;
          final updated = await Navigator.of(context).pushNamed(
            route,
            arguments: SubscriptionFlowArgs(request: request),
          );
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
    final warning = readiness.warning(locale.localeName).trim();

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
          ],
        ),
      ),
    );
  }
}
