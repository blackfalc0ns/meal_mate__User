import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddressDeleteConfirmationDialog extends StatelessWidget {
  const AddressDeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AlertDialog(
      backgroundColor: color.surface,
      surfaceTintColor: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.addressesCardRadius),
      ),
      icon: Icon(
        Icons.delete_outline_rounded,
        color: color.error,
        size: Spacing.iconXl,
      ),
      title: Text(
        locale.addresses_delete_confirmation_title,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size15,
          color: color.onSurface,
        ),
      ),
      content: Text(
        locale.addresses_delete_confirmation_message,
        textAlign: TextAlign.start,
        style: getRegularStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size13,
          color: color.onSurfaceVariant,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            locale.addresses_delete_confirmation_cancel,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            locale.addresses_delete_confirmation_action,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.error,
            ),
          ),
        ),
      ],
    );
  }
}
