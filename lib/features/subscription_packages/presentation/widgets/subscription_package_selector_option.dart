import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionPackageSelectorOption extends StatelessWidget {
  const SubscriptionPackageSelectorOption({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusLg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? color.primaryContainer.withValues(alpha: 0.82)
              : color.surface.withValues(alpha: 0),
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Spacing.iconSm,
              color: selected ? color.primary : color.onSurfaceVariant,
            ),
            const SizedBox(width: Spacing.xs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size12,
                  color: selected ? color.primary : color.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
