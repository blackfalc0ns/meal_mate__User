import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';

class AddressLoadingOverlay extends StatelessWidget {
  const AddressLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: color.scrim.withValues(alpha: 0.32),
          child: const Center(child: CustomProgressIndicator()),
        ),
      ),
    );
  }
}
