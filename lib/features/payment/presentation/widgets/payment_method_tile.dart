import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_method_logo.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_method_radio_dot.dart';

/// Single payment method tile with radio, icon, title & subtitle.
/// Strictly adheres to UI rules: single class per file, semantic colors,
/// Spacing tokens, and centralized styles.
class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethodEntity method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(
            color: isSelected ? color.primary : color.outlineVariant,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            PaymentMethodLogo(type: method.type),
            const SizedBox(width: Spacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _title(context),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurface,
                    ),
                  ),
                  _buildSubtitle(context),
                ],
              ),
            ),
            const SizedBox(width: Spacing.md),
            PaymentMethodRadioDot(isSelected: isSelected),
            const SizedBox(width: Spacing.md),
          ],
        ),
      ),
    );
  }

  String _title(BuildContext context) {
    if (method.title.isNotEmpty) return method.title;
    final locale = context.localization;
    return switch (method.type) {
      PaymentMethodType.mada => locale.payment_method_mada,
      PaymentMethodType.visa => locale.payment_method_visa,
      PaymentMethodType.applePay => locale.payment_method_apple,
      PaymentMethodType.wallet => locale.payment_method_wallet,
      PaymentMethodType.sandbox => locale.sandbox_checkout_title,
    };
  }

  String _subtitle(BuildContext context) {
    if (method.subtitle.isNotEmpty) return method.subtitle;
    final locale = context.localization;
    return switch (method.type) {
      PaymentMethodType.mada => locale.payment_method_mada_subtitle,
      PaymentMethodType.visa => locale.payment_method_visa_subtitle,
      PaymentMethodType.applePay => locale.payment_method_apple_subtitle,
      PaymentMethodType.wallet => locale.payment_method_wallet_balance,
      PaymentMethodType.sandbox => locale.sandbox_checkout_subtitle,
    };
  }

  Widget _buildSubtitle(BuildContext context) {
    final color = context.colorScheme;

    if (method.type == PaymentMethodType.wallet &&
        method.walletBalance != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${method.walletBalance!.toStringAsFixed(3)} KWD',
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            _subtitle(context),
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
    return Text(
      _subtitle(context),
      style: getMediumStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size10,
        color: color.onSurfaceVariant,
      ),
    );
  }
}
