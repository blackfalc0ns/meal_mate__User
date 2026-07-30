import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

/// ─────────────────────────────────────────────────────────────
/// Single payment method tile with radio, icon, title & subtitle.
/// ─────────────────────────────────────────────────────────────
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // ── Radio indicator ──
            _PaymentLogo(type: method.type),

            const SizedBox(width: Spacing.base),
            // ── Title + subtitle ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title(context),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  _buildSubtitle(context),
                ],
              ),
            ),
            const SizedBox(width: Spacing.md),
            _RadioDot(isSelected: isSelected),
            const SizedBox(width: Spacing.md),

            // ── Payment logo ──
          ],
        ),
      ),
    );
  }

  String _title(BuildContext context) {
    final l10n = context.localization;
    return switch (method.type) {
      PaymentMethodType.mada => l10n.payment_method_mada,
      PaymentMethodType.visa => l10n.payment_method_visa,
      PaymentMethodType.applePay => l10n.payment_method_apple,
      PaymentMethodType.wallet => l10n.payment_method_wallet,
    };
  }

  String _subtitle(BuildContext context) {
    final l10n = context.localization;
    return switch (method.type) {
      PaymentMethodType.mada => l10n.payment_method_mada_subtitle,
      PaymentMethodType.visa => l10n.payment_method_visa_subtitle,
      PaymentMethodType.applePay => l10n.payment_method_apple_subtitle,
      PaymentMethodType.wallet => l10n.payment_method_wallet_balance,
    };
  }

  Widget _buildSubtitle(BuildContext context) {
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
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _subtitle(context),
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: AppColors.textSecondary,
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
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 0 : 1.5,
        ),
        color: isSelected ? AppColors.primary : AppColors.white,
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.white, size: 14)
          : null,
    );
  }
}

/// Renders the brand logo for each payment method type.
class _PaymentLogo extends StatelessWidget {
  const _PaymentLogo({required this.type});

  final PaymentMethodType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PaymentMethodType.mada:
        return _MadaLogo();
      case PaymentMethodType.visa:
        return _VisaLogo();
      case PaymentMethodType.applePay:
        return _ApplePayLogo();
      case PaymentMethodType.wallet:
        return _WalletLogo();
    }
  }
}

class _MadaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [Color(0xFF004F9E), Color(0xFF0075BE)],
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        'مدى',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
          fontFamily: FontConstant.alexandria,
        ),
      ),
    );
  }
}

class _VisaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F71),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: const Text(
        'VISA',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 14,
          letterSpacing: 1.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _ApplePayLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apple, color: Colors.white, size: 16),
          SizedBox(width: 2),
          Text(
            'Pay',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 26,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.account_balance_wallet_rounded,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }
}
