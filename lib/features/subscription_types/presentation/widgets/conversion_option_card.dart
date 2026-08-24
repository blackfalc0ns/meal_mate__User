import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';

class ConversionOptionCard extends StatelessWidget {
  const ConversionOptionCard({
    super.key,
    required this.option,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final ConversionOptionModel option;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isEnabled = option.available;
    final accentColor = option.isConvertToFamilyManager
        ? color.primary
        : color.secondary;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: title,
      child: Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              color: isEnabled
                  ? color.surface
                  : color.surfaceContainerHighest.withValues(alpha: 0.56),
              borderRadius: BorderRadius.circular(Spacing.radiusLg),
              border: Border.all(
                color: isSelected ? accentColor : color.outlineVariant,
                width: isSelected
                    ? Spacing.border + Spacing.hairline
                    : Spacing.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: Spacing.iconXl,
                  height: Spacing.iconXl,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: Spacing.iconMd,
                    color: isEnabled ? accentColor : color.onSurfaceVariant,
                    semanticLabel: title,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: isEnabled
                              ? color.onSurface
                              : color.onSurfaceVariant,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: Spacing.xs),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Icon(
                  isEnabled
                      ? isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded
                      : Icons.lock_clock_rounded,
                  color: isEnabled
                      ? isSelected
                            ? accentColor
                            : color.onSurfaceVariant
                      : color.onSurfaceVariant,
                  size: Spacing.iconMd,
                  semanticLabel: isEnabled
                      ? locale.subscription_conversion_option_available
                      : locale.subscription_conversion_option_unavailable,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
