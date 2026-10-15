import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
    this.canEdit = true,
  });

  final CustomerAddressEntity? currentDeliveryAddress;
  final List<CustomerAddressEntity> addresses;
  final ValueChanged<CustomerAddressEntity> onEdit;
  final ValueChanged<CustomerAddressEntity> onSetDefault;
  final ValueChanged<CustomerAddressEntity> onDelete;
  final VoidCallback onAddAddress;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

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
            if (!canEdit) ...[
              Container(
                margin: const EdgeInsets.only(bottom: Spacing.base),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.base,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: color.errorContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  border: Border.all(
                    color: color.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: Spacing.iconMd,
                      color: color.error,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        locale.localeName == 'ar'
                            ? 'العناوين للعرض فقط. تم قفل التعديل والإضافة من قِبل مدير العائلة.'
                            : 'Addresses are read-only. Editing is locked by the family manager.',
                        style: TextStyle(
                          fontSize: 12,
                          color: color.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            CurrentAddressSection(address: currentDeliveryAddress),
            SavedAddressesSection(
              addresses: addresses,
              canEdit: canEdit,
              onEdit: onEdit,
              onSetDefault: onSetDefault,
              onDelete: onDelete,
            ),
            if (canEdit) ...[
              const SizedBox(height: Spacing.addressesSectionGap),
              AddressesActionsSection(onAddAddress: onAddAddress),
            ],
          ],
        ),
      ),
    );
  }
}
