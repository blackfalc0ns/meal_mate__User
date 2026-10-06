import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/saved_address_tile.dart';

class SavedAddressesSection extends StatelessWidget {
  const SavedAddressesSection({
    super.key,
    required this.addresses,
    required this.onEdit,
    required this.onSetDefault,
    required this.onDelete,
  });

  final List<CustomerAddressEntity> addresses;
  final ValueChanged<CustomerAddressEntity> onEdit;
  final ValueChanged<CustomerAddressEntity> onSetDefault;
  final ValueChanged<CustomerAddressEntity> onDelete;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (addresses.isEmpty) {
      return EmptyStateWidget(
        title: locale.addresses_saved_section,
        description: locale.addresses_add_new,
        icon: Icons.location_off_rounded,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          locale.addresses_saved_section,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size13,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: addresses.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: Spacing.addressesCardGap),
          itemBuilder: (context, index) {
            final address = addresses[index];
            return SavedAddressTile(
              icon: _iconForAddress(address),
              title: address.label,
              address: address.addressLine,
              isDefault: address.isDefault,
              canDelete: address.canDelete,
              onEdit: () => onEdit(address),
              onSetDefault: address.addressId.isEmpty || address.isDefault
                  ? null
                  : () => onSetDefault(address),
              onDelete: address.addressId.isEmpty
                  ? null
                  : () => onDelete(address),
            );
          },
        ),
      ],
    );
  }

  IconData _iconForAddress(CustomerAddressEntity address) {
    final label = address.label.trim().toLowerCase();
    if (label.contains('work') ||
        label.contains('office') ||
        label.contains('عمل') ||
        label.contains('مكتب') ||
        label.contains('شغل')) {
      return Icons.business_center_rounded;
    }
    if (label.contains('home') ||
        label.contains('house') ||
        label.contains('منزل') ||
        label.contains('بيت') ||
        label.contains('سكن') ||
        label.contains('شقة')) {
      return Icons.home_rounded;
    }
    return Icons.location_on_rounded;
  }
}
