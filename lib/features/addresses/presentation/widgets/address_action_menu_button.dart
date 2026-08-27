import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_delete_confirmation_dialog.dart';

enum AddressActionMenuItem { edit, setDefault, delete }

class AddressActionMenuButton extends StatelessWidget {
  const AddressActionMenuButton({
    super.key,
    this.onEdit,
    this.onSetDefault,
    this.onDelete,
    this.canDelete = true,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onSetDefault;
  final VoidCallback? onDelete;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return PopupMenuButton<AddressActionMenuItem>(
      color: color.surface,
      surfaceTintColor: color.surface,
      elevation: Spacing.cardElevation,
      offset: const Offset(0, Spacing.addressesOverflowButtonSize),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
      ),
      onSelected: (item) async {
        switch (item) {
          case AddressActionMenuItem.edit:
            onEdit?.call();
          case AddressActionMenuItem.setDefault:
            onSetDefault?.call();
          case AddressActionMenuItem.delete:
            if (!canDelete || onDelete == null) return;
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => const AddressDeleteConfirmationDialog(),
            );
            if (confirmed == true) onDelete?.call();
        }
      },
      itemBuilder: (context) => [
        _item(
          context: context,
          value: AddressActionMenuItem.edit,
          icon: Icons.edit_rounded,
          label: locale.addresses_edit,
          enabled: onEdit != null,
        ),
        _item(
          context: context,
          value: AddressActionMenuItem.setDefault,
          icon: Icons.home_rounded,
          label: locale.addresses_set_default,
          enabled: onSetDefault != null,
        ),
        _item(
          context: context,
          value: AddressActionMenuItem.delete,
          icon: Icons.delete_rounded,
          label: locale.addresses_delete,
          enabled: canDelete && onDelete != null,
          isDestructive: true,
        ),
      ],
      child: Container(
        width: Spacing.addressesOverflowButtonSize,
        height: Spacing.addressesOverflowButtonSize,
        decoration: BoxDecoration(
          color: color.secondaryContainer,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.more_horiz_rounded,
          color: color.primary,
          size: Spacing.iconMd,
        ),
      ),
    );
  }

  PopupMenuEntry<AddressActionMenuItem> _item({
    required BuildContext context,
    required AddressActionMenuItem value,
    required IconData icon,
    required String label,
    required bool enabled,
    bool isDestructive = false,
  }) {
    final color = context.colorScheme;
    final itemColor = !enabled
        ? color.onSurfaceVariant
        : isDestructive
        ? color.error
        : color.primary;

    return PopupMenuItem<AddressActionMenuItem>(
      value: value,
      enabled: enabled,
      height: Spacing.buttonSmallHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Spacing.iconSm, color: itemColor),
          const SizedBox(width: Spacing.sm),
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: itemColor,
            ),
          ),
        ],
      ),
    );
  }
}
