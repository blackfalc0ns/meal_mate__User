import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_map_view.dart';

class AddressChooseLocationMapSection extends StatelessWidget {
  const AddressChooseLocationMapSection({
    super.key,
    required this.locations,
    required this.isSubmitting,
    this.initialAddress,
  });

  final LocationsCatalogState locations;
  final bool isSubmitting;
  final CustomerAddressEntity? initialAddress;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Semantics(
      label: locale.addresses_choose_location_title,
      child: AddressChooseLocationMapView(
        locations: locations,
        isSubmitting: isSubmitting,
        initialAddress: initialAddress,
      ),
    );
  }
}
