import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/current_address_card.dart';

class CurrentAddressSection extends StatelessWidget {
  const CurrentAddressSection({super.key, this.address});

  final CustomerAddressEntity? address;

  @override
  Widget build(BuildContext context) {
    final currentAddress = address;
    if (currentAddress == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.addressesSectionGap),
      child: CurrentAddressCard(address: currentAddress)
          .animate()
          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
          .slideY(
            begin: 0.08,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}
