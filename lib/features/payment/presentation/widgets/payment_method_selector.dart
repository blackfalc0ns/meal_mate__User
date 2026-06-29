import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_method_tile.dart';

/// ─────────────────────────────────────────────────────────────
/// Section that lists all available payment methods and tracks
/// the selected one. Calls [onMethodSelected] on change.
/// ─────────────────────────────────────────────────────────────
class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.methods,
    required this.selectedType,
    required this.onMethodSelected,
  });

  final List<PaymentMethodEntity> methods;
  final PaymentMethodType selectedType;
  final ValueChanged<PaymentMethodType> onMethodSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            l10n.payment_method_section_title,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.md),
          ...methods.map(
            (method) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: PaymentMethodTile(
                method: method,
                isSelected: method.type == selectedType,
                onTap: () => onMethodSelected(method.type),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
