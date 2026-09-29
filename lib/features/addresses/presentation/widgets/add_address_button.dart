import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddAddressButton extends StatelessWidget {
  const AddAddressButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.addressesAddButtonHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.add_circle_rounded,
          color: color.primary,
          size: Spacing.iconLg,
        ),
        label: Text(
          locale.addresses_add_new,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.primaryContainer),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.addressesCardRadius),
          ),
        ),
      ),
    );
  }
}
