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
            color: isSelected ? color.surface : color.surfaceContainerLow,
            borderRadius: BorderRadius.circular(
              Spacing.subscriptionProgramCardRadius,
            ),
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildIconBox(context),
                  const SizedBox(width: Spacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.name(locale.localeName),
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.family_package_members_range(
                          package.minMembers,
                          package.maxMembers,
                        ),
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSelectionIndicator(context),
                      if (package.discountPercent > 0) ...[
                        const SizedBox(height: Spacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.sm,
                            vertical: Spacing.hairline * 3,
                          ),
                          decoration: BoxDecoration(
                            color: color.primary.withValues(alpha: 0.12),
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
                              fontSize: FontSize.size10,
                              color: color.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: Spacing.iconSm,
                    color: color.onSurfaceVariant,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    locale.family_packages_default_meals_range,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Container(width: 1, height: 11, color: color.outlineVariant),
                  const SizedBox(width: Spacing.sm),
                  Icon(
                    Icons.groups_outlined,
                    size: Spacing.iconSm,
                    color: color.onSurfaceVariant,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    locale.family_packages_members_count(
                      package.minMembers,
                      package.maxMembers,
                    ),
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context) {
    final color = context.colorScheme;
    if (isSelected) {
      return Container(
        width: Spacing.iconMd,
        height: Spacing.iconMd,
        decoration: BoxDecoration(color: color.primary, shape: BoxShape.circle),
        child: Icon(
          Icons.check_rounded,
          color: color.onPrimary,
          size: Spacing.iconSm,
        ),
      );
    }
    return Container(
      width: Spacing.iconMd,
      height: Spacing.iconMd,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.outlineVariant, width: 1.5),
      ),
    );
  }

  Widget _buildIconBox(BuildContext context) {
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
        color: color.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Icon(
        Icons.groups_2_rounded,
        color: color.primary,
        size: Spacing.iconLg,
      ),
    );
  }
}
