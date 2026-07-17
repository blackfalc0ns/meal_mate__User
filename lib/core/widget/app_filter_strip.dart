import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Reusable segmented filter used by feature pages such as Offers and Calendar.
class AppFilterStrip extends StatelessWidget {
  const AppFilterStrip({
    super.key,
    required this.items,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: Spacing.sm),
    this.height = Spacing.xxxl - Spacing.md,
  });

  final List<AppFilterItem> items;
  final ValueChanged<int>? onTap;
  final EdgeInsetsGeometry padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return Padding(
              padding: EdgeInsetsDirectional.only(
                end: index == items.length - 1 ? 0 : Spacing.sm,
              ),
              child: _FilterChip(
                item: item,
                height: height,
                onTap: onTap == null ? null : () => onTap!(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AppFilterItem {
  const AppFilterItem({
    required this.label,
    this.icon,
    this.isSelected = false,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.item, required this.height, this.onTap});

  final AppFilterItem item;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final foreground = item.isSelected
        ? color.onPrimary
        : color.onPrimaryContainer;

    return Material(
      color: color.surface.withValues(alpha: 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        onTap: onTap,
        child: Ink(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
          decoration: BoxDecoration(
            color: item.isSelected ? color.primary : color.primaryContainer,
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            border: Border.all(
              color: item.isSelected
                  ? color.primary
                  : color.primary.withValues(alpha: 0.24),
            ),
            boxShadow: item.isSelected
                ? [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.12),
                      blurRadius: Spacing.xs,
                      offset: const Offset(0, Spacing.xs / 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(item.icon!, size: Spacing.iconSm, color: foreground),
                const SizedBox(width: Spacing.xs),
              ],
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size12,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
