import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';

class SubscriptionReadinessBottomSheet extends StatelessWidget {
  const SubscriptionReadinessBottomSheet({
    super.key,
    required this.readiness,
    required this.onItemPressed,
  });

  final SubscriptionReadinessEntity readiness;
  final ValueChanged<SubscriptionReadinessItemEntity> onItemPressed;

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
