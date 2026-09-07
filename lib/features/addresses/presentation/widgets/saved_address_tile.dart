import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_action_menu_button.dart';

class SavedAddressTile extends StatelessWidget {
  const SavedAddressTile({
    super.key,
    required this.icon,
    required this.title,
    required this.address,
    this.isDefault = false,
    this.canDelete = true,
    this.onEdit,
    this.onSetDefault,
    this.onDelete,
  });

  final IconData icon;
  final String title;
  final String address;
  final bool isDefault;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onSetDefault;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      key: isDefault ? const Key('default_saved_address_tile') : null,
      height: Spacing.addressesSavedTileHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.addressesCardContentPadding,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.addressesCardRadius),
        border: Border.all(
          color: isDefault ? color.primary : color.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.07),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: Spacing.addressesIconContainerSize,
            height: Spacing.addressesIconContainerSize,
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              borderRadius: BorderRadius.circular(Spacing.addressesIconRadius),
            ),
            child: Icon(icon, color: color.primary, size: Spacing.iconMd),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xs,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: color.secondaryContainer,
                          borderRadius: BorderRadius.circular(Spacing.radiusXs),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: color.primary,
                              size: Spacing.xs,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              locale.addresses_default,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size8,
                                color: color.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: getLightStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          AddressActionMenuButton(
            onEdit: onEdit,
            onSetDefault: onSetDefault,
            onDelete: onDelete,
            canDelete: canDelete,
          ),
        ],
      ),
    );
  }
}
