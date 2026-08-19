import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_method_card.dart';

class FamilyPaymentMethodsSection extends StatelessWidget {
  const FamilyPaymentMethodsSection({super.key, required this.methods});

  final List<FamilyPaymentMethodUiModel> methods;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.family_payment_method_title,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.primary,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Row(
          children: [
            for (final method in methods) ...[
              Expanded(child: FamilyPaymentMethodCard(method: method)),
              if (method != methods.last) const SizedBox(width: Spacing.md),
            ],
          ],
        ),
      ],
    );
  }
}
