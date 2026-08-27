import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddressDeliveryNoticeDialog extends StatelessWidget {
  const AddressDeliveryNoticeDialog({super.key, required this.message});

  final String message;

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
        Icons.info_outline_rounded,
        color: color.primary,
        size: Spacing.iconXl,
      ),
      title: Text(
        locale.addresses_delivery_notice_title,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size15,
          color: color.onSurface,
        ),
      ),
      content: Text(
        message,
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            locale.addresses_delivery_notice_action,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.primary,
            ),
          ),
        ),
      ],
    );
  }
}
