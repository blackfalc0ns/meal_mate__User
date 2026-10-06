import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        AddAddressButton(onPressed: onAddAddress)
            .animate()
            .fadeIn(delay: 260.ms, duration: 350.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.08,
              end: 0,
              delay: 260.ms,
              duration: 350.ms,
              curve: Curves.easeOutCubic,
            ),
        const SizedBox(height: Spacing.addressesSectionGap),
        const AddressesAvailabilityNotice()
            .animate()
            .fadeIn(delay: 340.ms, duration: 350.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.08,
              end: 0,
              delay: 340.ms,
              duration: 350.ms,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }
}
