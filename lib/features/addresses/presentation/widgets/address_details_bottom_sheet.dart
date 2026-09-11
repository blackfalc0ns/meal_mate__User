import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/location_confirmation_card.dart';

class AddressDetailsBottomSheet extends StatefulWidget {
  const AddressDetailsBottomSheet({
    super.key,
    required this.onConfirm,
    required this.isLoading,
    required this.content,
  });

  final VoidCallback onConfirm;
  final bool isLoading;
  final Widget content;

  @override
  State<AddressDetailsBottomSheet> createState() =>
      _AddressDetailsBottomSheetState();
}

class _AddressDetailsBottomSheetState extends State<AddressDetailsBottomSheet> {
  static const double _collapsedSize = 0.45;
  static const double _expandedSize = 0.72;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_sheetController.isAttached) return;
      _sheetController.animateTo(
        _expandedSize,
        duration: AppDurations.normal,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _collapsedSize,
      minChildSize: _collapsedSize,
      maxChildSize: 0.94,
      snap: true,
      snapSizes: const [_expandedSize, 0.94],
      expand: false,
      builder: (context, scrollController) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final scale =
                constraints.maxWidth / Spacing.addressesChooseLocationCardWidth;
            final designViewportHeight = constraints.maxHeight / scale;

            return FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: Spacing.addressesChooseLocationCardWidth,
                height: designViewportHeight,
                child: LocationConfirmationCard(
                  isLoading: widget.isLoading,
                  onConfirm: widget.onConfirm,
                  scrollController: scrollController,
                  primaryButtonText: locale.address_preview_check_button,
                  content: widget.content,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
