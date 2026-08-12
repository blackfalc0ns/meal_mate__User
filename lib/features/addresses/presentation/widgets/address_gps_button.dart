import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddressGpsButton extends StatelessWidget {
  const AddressGpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.addressesChooseLocationGpsSize,
      height: Spacing.addressesChooseLocationGpsSize,
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outline, width: 0.662),
        borderRadius: BorderRadius.circular(
          Spacing.addressesChooseLocationGpsRadius,
        ),
      ),
      child: Center(
        child: Semantics(
          label: locale.addresses_use_current_location,
          child: SvgPicture.asset(
            Assets.addressesIconGps,
            width: Spacing.addressesChooseLocationGpsIconSize,
            height: Spacing.addressesChooseLocationGpsIconSize,
          ),
        ),
      ),
    );
  }
}
