import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_gps_button.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_map_marker.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/current_location_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/home_address_form_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/location_confirmation_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressesFigmaFrame extends StatelessWidget {
  const AddressesFigmaFrame({super.key, required this.locations});

  final LocationsCatalogState locations;

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
              children: [
                const LocationConfirmationCard(),
                const SizedBox(
                  height: Spacing.addressesChooseLocationColumnGap,
                ),
                HomeAddressFormCard(
                  governorates: locations.governorates,
                  areas: locations.areas,
                  blocks: locations.blocks,
                  selectedGovernorate: locations.selectedGovernorate,
                  selectedArea: locations.selectedArea,
                  selectedBlock: locations.selectedBlock,
                  onGovernorateSelected: (governorate) {
                    context.read<AddressesViewModel>().doIntent(
                      SelectAddressGovernorateEvent(governorate),
                    );
                  },
                  onAreaSelected: (area) {
                    context.read<AddressesViewModel>().doIntent(
                      SelectAddressAreaEvent(area),
                    );
                  },
                  onBlockSelected: (block) {
                    context.read<AddressesViewModel>().doIntent(
                      SelectAddressBlockEvent(block),
                    );
                  },
                ),
                const SizedBox(
                  height: Spacing.addressesChooseLocationColumnGap,
                ),
                const CurrentLocationCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
