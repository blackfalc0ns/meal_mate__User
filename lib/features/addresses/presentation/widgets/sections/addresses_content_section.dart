import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/sections/addresses_actions_section.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/sections/current_address_section.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/sections/saved_addresses_section.dart';

class AddressesContentSection extends StatelessWidget {
  const AddressesContentSection({
    super.key,
    this.currentDeliveryAddress,
    required this.addresses,
    required this.onEdit,
    required this.onSetDefault,
    required this.onDelete,
    required this.onAddAddress,
  });

  final CustomerAddressEntity? currentDeliveryAddress;
  final List<CustomerAddressEntity> addresses;
  final ValueChanged<CustomerAddressEntity> onEdit;
  final ValueChanged<CustomerAddressEntity> onSetDefault;
  final ValueChanged<CustomerAddressEntity> onDelete;
  final VoidCallback onAddAddress;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(
              horizontal: Spacing.addressesScreenHorizontalPadding,
            ).copyWith(
              top: Spacing.addressesContentTopPadding,
              bottom: Spacing.xxxl,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CurrentAddressSection(address: currentDeliveryAddress),
            SavedAddressesSection(
              addresses: addresses,
              onEdit: onEdit,
              onSetDefault: onSetDefault,
              onDelete: onDelete,
            ),
            const SizedBox(height: Spacing.addressesSectionGap),
            AddressesActionsSection(onAddAddress: onAddAddress),
          ],
        ),
      ),
    );
  }
}
