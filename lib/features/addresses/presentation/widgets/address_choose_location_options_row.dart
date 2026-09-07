import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_mode_card.dart';

enum AddressLocationMode { fromMap, currentLocation }

class AddressChooseLocationOptionsRow extends StatelessWidget {
  const AddressChooseLocationOptionsRow({
    super.key,
    required this.selectedMode,
    this.onModeChanged,
    this.onUseCurrentLocation,
  });

  final AddressLocationMode? selectedMode;
  final ValueChanged<AddressLocationMode>? onModeChanged;
  final VoidCallback? onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        Expanded(
          child: AddressChooseLocationModeCard(
            title: locale.addresses_choose_from_map,
            subtitle: locale.addresses_choose_from_map_subtitle,
            isSelected: selectedMode == AddressLocationMode.fromMap,
            onTap: () => onModeChanged?.call(AddressLocationMode.fromMap),
            icon: Container(
              width: Spacing.iconXl,
              height: Spacing.iconXl,
              decoration: BoxDecoration(
                color: color.secondaryContainer,
                borderRadius: BorderRadius.circular(Spacing.xs),
              ),
              child: Icon(
                Icons.map_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: AddressChooseLocationModeCard(
            title: locale.addresses_use_current_location,
            subtitle: locale.addresses_use_current_location_desc,
            isSelected: selectedMode == AddressLocationMode.currentLocation,
            onTap: () {
              onModeChanged?.call(AddressLocationMode.currentLocation);
              onUseCurrentLocation?.call();
            },
            icon: SvgPicture.asset(
              Assets.addressesIconGps,
              width: Spacing.iconLg,
              height: Spacing.iconLg,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }
}
