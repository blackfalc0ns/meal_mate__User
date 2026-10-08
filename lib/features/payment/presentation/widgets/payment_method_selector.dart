import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_method_tile.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.methods,
    required this.selectedMethodId,
    required this.onMethodSelected,
  });

  final List<PaymentMethodEntity> methods;
  final int? selectedMethodId;
  final ValueChanged<PaymentMethodEntity> onMethodSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.payment_method_section_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          ...methods.map(
            (method) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: PaymentMethodTile(
                method: method,
                isSelected: method.id != null && method.id == selectedMethodId,
                onTap: () => onMethodSelected(method),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
