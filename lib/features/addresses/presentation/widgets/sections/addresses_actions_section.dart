import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/add_address_button.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_availability_notice.dart';

class AddressesActionsSection extends StatelessWidget {
  const AddressesActionsSection({super.key, required this.onAddAddress});

  final VoidCallback onAddAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddAddressButton(onPressed: onAddAddress),
        const SizedBox(height: Spacing.addressesSectionGap),
        const AddressesAvailabilityNotice(),
      ],
    );
  }
}
