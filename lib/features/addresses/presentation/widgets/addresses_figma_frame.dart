import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_gps_button.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_map_marker.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/current_location_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/home_address_form_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/location_confirmation_card.dart';

class AddressesFigmaFrame extends StatelessWidget {
  const AddressesFigmaFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.addresses_choose_location_title,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: color.surfaceContainerHighest,
              child: Image.asset(
                Assets.addressesChooseLocationMap,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          const PositionedDirectional(
            start: Spacing.addressesChooseLocationGpsStart,
            top: Spacing.addressesChooseLocationGpsTop,
            child: AddressGpsButton(),
          ),
          const Positioned.fill(child: AddressMapMarker()),
          PositionedDirectional(
            start: Spacing.addressesChooseLocationColumnStart,
            top: Spacing.addressesChooseLocationColumnTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                LocationConfirmationCard(),
                SizedBox(height: Spacing.addressesChooseLocationColumnGap),
                HomeAddressFormCard(),
                SizedBox(height: Spacing.addressesChooseLocationColumnGap),
                CurrentLocationCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
