import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class AddressesFigmaFrame extends StatelessWidget {
  const AddressesFigmaFrame({super.key, required this.locations});

  static const double locationConfirmationCardHeight =
      (Spacing.addressesChooseLocationCardPadding * 2) +
      ((Spacing.addressesChooseLocationTitleSize +
              Spacing.addressesChooseLocationSubtitleSize) *
          Spacing.addressesChooseLocationLineHeight) +
      Spacing.addressesChooseLocationHeaderGap +
      Spacing.addressesChooseLocationLineHeight +
      Spacing.addressesChooseLocationHeaderGap +
      Spacing.addressesChooseLocationButtonHeight;
  static const double frameHeight =
      Spacing.addressesChooseLocationColumnTop +
      locationConfirmationCardHeight +
      Spacing.addressesChooseLocationColumnGap +
      Spacing.addressesHomeFormHeight +
      Spacing.addressesChooseLocationColumnGap +
      Spacing.addressesCurrentLocationCardHeight +
      Spacing.addressesChooseLocationBottomPadding;

  final LocationsCatalogState locations;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.addresses_choose_location_title,
      child: Container(
        width: Spacing.addressesChooseLocationDesignWidth,
        height: frameHeight,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          image: const DecorationImage(
            image: AssetImage(Assets.addressesChooseLocationMap),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: Spacing.addressesChooseLocationGpsTop),
            const Padding(
              padding: EdgeInsetsDirectional.only(
                start: Spacing.addressesChooseLocationGpsStart,
              ),
              child: Row(children: [AddressGpsButton()]),
            ),
            const SizedBox(
              height:
                  Spacing.addressesChooseLocationBadgeTop -
                  Spacing.addressesChooseLocationGpsTop -
                  Spacing.addressesChooseLocationGpsSize,
            ),
            const AddressMapMarker(),
            const SizedBox(
              height:
                  Spacing.addressesChooseLocationColumnTop -
                  Spacing.addressesChooseLocationPinTop -
                  Spacing.addressesChooseLocationPinSize,
            ),
            Center(
              child: Column(
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
                  const SizedBox(
                    height: Spacing.addressesChooseLocationBottomPadding,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
