import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class AddressMapMarker extends StatelessWidget {
  const AddressMapMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Spacing.addressesChooseLocationDesignWidth,
      height: Spacing.addressesChooseLocationMarkerHeight,
      child: Column(
        children: [
          // ),
          const SizedBox(height: Spacing.addressesChooseLocationMarkerGap),
          SvgPicture.asset(
            Assets.addressesIconPin,
            width: Spacing.iconXl,
            height: Spacing.iconXl,
          ),
        ],
      ),
    );
  }
}
