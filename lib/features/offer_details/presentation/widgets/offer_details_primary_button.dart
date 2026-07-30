import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OfferDetailsPrimaryButton extends StatelessWidget {
  const OfferDetailsPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.offerDetailsBottomButtonHeight,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.primary, color.tertiary],
          ),
          borderRadius: BorderRadius.circular(
            Spacing.offerDetailsBottomButtonRadius,
          ),
        ),
        child: Material(
          color: color.scrim.withValues(alpha: 0),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(
              Spacing.offerDetailsBottomButtonRadius,
            ),
            child: Center(
              child: Text(
                label,
                semanticsLabel: locale.offer_details_plan_section_title,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size20,
                  color: color.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
