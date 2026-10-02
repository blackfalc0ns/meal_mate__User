import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Terms and conditions text section on the offer activation screen.
class ActivationTermsSection extends StatelessWidget {
  const ActivationTermsSection({super.key, required this.terms});

  final String terms;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    if (terms.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.md),
      child: Text(
        terms,
        style: getRegularStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size12,
          color: color.outline,
        ),
      ),
    );
  }
}
