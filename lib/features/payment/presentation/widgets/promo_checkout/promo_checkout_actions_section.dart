import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

/// Bottom action buttons for the promo checkout screen.
class PromoCheckoutActionsSection extends StatelessWidget {
  const PromoCheckoutActionsSection({
    super.key,
    required this.isLoading,
    required this.onProceed,
    required this.onChangePackage,
  });

  final bool isLoading;
  final VoidCallback? onProceed;
  final VoidCallback? onChangePackage;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: locale.offer_checkout_proceed_button,
          isLoading: isLoading,
          onPressed: isLoading ? null : onProceed,
        ),
        const SizedBox(height: Spacing.md),
        TextButton(
          onPressed: isLoading ? null : onChangePackage,
          child: Text(
            locale.offer_checkout_change_package_button,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.primary,
            ),
          ),
        ),
      ],
    );
  }
}
