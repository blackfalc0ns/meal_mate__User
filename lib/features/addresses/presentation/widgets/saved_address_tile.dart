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
    this.canDelete = true,
    this.onEdit,
    this.onSetDefault,
    this.onDelete,
  });

  final IconData icon;
  final String title;
  final String address;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onSetDefault;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.addressesSavedTileHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.addressesCardContentPadding,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.addressesCardRadius),
        border: Border.all(color: color.outlineVariant),
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
                Text(
                  title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
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
