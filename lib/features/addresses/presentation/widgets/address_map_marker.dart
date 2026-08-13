import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddressMapMarker extends StatelessWidget {
  const AddressMapMarker({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: Spacing.addressesChooseLocationDesignWidth,
      height:
          Spacing.addressesChooseLocationBadgeHeight +
          (Spacing.addressesChooseLocationPinTop -
              Spacing.addressesChooseLocationBadgeTop -
              Spacing.addressesChooseLocationBadgeHeight) +
          Spacing.addressesChooseLocationPinSize,
      child: Column(
        children: [
          Container(
            width: Spacing.addressesChooseLocationBadgeWidth,
            height: Spacing.addressesChooseLocationBadgeHeight,
            decoration: BoxDecoration(
              color: color.secondary,
              border: Border.all(color: color.surface, width: 0.828),
              borderRadius: BorderRadius.circular(
                Spacing.addressesChooseLocationBadgeRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.2),
                  blurRadius: Spacing.xss,
                  offset: const Offset(0, Spacing.xss),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.addressesIconHomeOutline,
                  width: Spacing.addressesChooseLocationBadgeIconSize,
                  height: Spacing.addressesChooseLocationBadgeIconSize,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.addresses_current_home,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height:
                Spacing.addressesChooseLocationPinTop -
                Spacing.addressesChooseLocationBadgeTop -
                Spacing.addressesChooseLocationBadgeHeight,
          ),
          SvgPicture.asset(
            Assets.addressesIconPin,
            width: Spacing.addressesChooseLocationPinSize,
            height: Spacing.addressesChooseLocationPinSize,
          ),
        ],
      ),
    );
  }
}
