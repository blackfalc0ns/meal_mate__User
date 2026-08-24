import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';

class FamilySizePackageCard extends StatelessWidget {
  const FamilySizePackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  final FamilySizePackageEntity package;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      button: true,
      selected: isSelected,
      label: package.name(locale.localeName),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.primary.withValues(alpha: 0.05)
                : color.surfaceContainerLow,
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              _buildPackageImage(context),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            package.name(locale.localeName),
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size14,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                        if (package.discountPercent > 0) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.primary,
                              borderRadius: BorderRadius.circular(
                                Spacing.radiusPill,
                              ),
                            ),
                            child: Text(
                              locale.family_package_discount_badge(
                                package.discountLabel,
                              ),
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size9,
                                color: color.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      locale.family_package_members_range(
                        package.minMembers,
                        package.maxMembers,
                      ),
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected ? color.primary : color.outline,
                size: Spacing.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageImage(BuildContext context) {
    final imageUrl = package.imageUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        child: SizedBox(
          width: Spacing.familyPackageCardImageSize,
          height: Spacing.familyPackageCardImageSize,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildFallbackIcon(context),
          ),
        ),
      );
    }

    return _buildFallbackIcon(context);
  }

  Widget _buildFallbackIcon(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      width: Spacing.familyPackageCardImageSize,
      height: Spacing.familyPackageCardImageSize,
      decoration: BoxDecoration(
        color: isSelected
            ? color.primary.withValues(alpha: 0.12)
            : color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Icon(
        Icons.groups_2_rounded,
        color: isSelected ? color.primary : color.onSurfaceVariant,
        size: Spacing.iconLg,
      ),
    );
  }
}
