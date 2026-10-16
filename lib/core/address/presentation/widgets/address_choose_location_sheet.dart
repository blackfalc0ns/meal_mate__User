import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_header.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_options_row.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_search_bar.dart';

class AddressChooseLocationSheet extends StatelessWidget {
  const AddressChooseLocationSheet({
    super.key,
    required this.selectedMode,
    required this.isSubmitting,
    this.searchController,
    this.onSearchSubmitted,
    this.onSearchChanged,
    this.onModeChanged,
    this.onUseCurrentLocation,
    this.onConfirm,
    this.confirmButtonText,
    this.confirmButtonIcon,
  });

  final AddressLocationMode? selectedMode;
  final bool isSubmitting;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchSubmitted;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<AddressLocationMode>? onModeChanged;
  final VoidCallback? onUseCurrentLocation;
  final VoidCallback? onConfirm;
  final String? confirmButtonText;
  final Widget? confirmButtonIcon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: Spacing.base,
            offset: const Offset(Spacing.zero, -Spacing.xs),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AddressChooseLocationHeader(),
            const SizedBox(height: Spacing.md),
            AddressChooseLocationSearchBar(
              controller: searchController,
              onSubmitted: onSearchSubmitted,
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: Spacing.md),
            AddressChooseLocationOptionsRow(
              selectedMode: selectedMode,
              onModeChanged: onModeChanged,
              onUseCurrentLocation: onUseCurrentLocation,
            ),
            const SizedBox(height: Spacing.md),
            AppButton.filled(
              text: confirmButtonText ?? locale.address_preview_check_button,
              isLoading: false,
              onPressed: isSubmitting ? null : onConfirm,
              height: Spacing.buttonSmallHeight,
              borderRadius: Spacing.radiusPill,
              color: color.primary,
              textColor: color.onPrimary,
              fontSize: FontSize.size12,
              iconWidget: confirmButtonIcon,
              iconBeforeText: false,
            ),
          ],
        ),
      ),
    );
  }
}
