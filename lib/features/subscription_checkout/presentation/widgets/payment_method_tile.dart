import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_method_logo.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/payment_method_radio_dot.dart';

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
    final isAvailable = method.isAvailable;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: isAvailable ? onTap : null,
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
              color: isSelected && isAvailable
                  ? color.primary
                  : color.outlineVariant,
              width: isSelected && isAvailable ? 1.5 : 1.0,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _buildSubtitle(context),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.md),
              PaymentMethodRadioDot(isSelected: isSelected && isAvailable),
              const SizedBox(width: Spacing.md),
            ],
          ),
        ),
      ),
    );
  }

  String _title(BuildContext context) {
    if (method.title.isNotEmpty) return method.title;
    final locale = context.localization;
    return switch (method.type) {
      PaymentMethodType.payzah => locale.payment_method_payzah,
      PaymentMethodType.mada => locale.payment_method_mada,
      PaymentMethodType.visa => locale.payment_method_visa,
      PaymentMethodType.applePay => locale.payment_method_apple,
      PaymentMethodType.wallet => locale.payment_method_wallet,
      PaymentMethodType.unknown =>
        method.title.isNotEmpty ? method.title : 'Payment',
    };
  }

  String _subtitle(BuildContext context) {
    final locale = context.localization;

    if (!method.isAvailable) {
      if (method.unavailableReason == 'wallet_not_implemented') {
        return locale.payment_method_unavailable_wallet;
      }
      if (method.unavailableReason != null &&
          method.unavailableReason!.trim().isNotEmpty) {
        return method.unavailableReason!;
      }
      return locale.payment_method_unavailable_generic;
    }

    if (method.subtitle.isNotEmpty) return method.subtitle;

    return switch (method.type) {
      PaymentMethodType.payzah => locale.payment_method_payzah_subtitle,
      PaymentMethodType.mada => locale.payment_method_mada_subtitle,
      PaymentMethodType.visa => locale.payment_method_visa_subtitle,
      PaymentMethodType.applePay => locale.payment_method_apple_subtitle,
      PaymentMethodType.wallet => locale.payment_method_wallet_balance,
      PaymentMethodType.unknown => '',
    };
  }

  Widget _buildSubtitle(BuildContext context) {
    final color = context.colorScheme;

    if (method.isAvailable &&
        method.type == PaymentMethodType.wallet &&
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
        color: !method.isAvailable ? color.error : color.onSurfaceVariant,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
