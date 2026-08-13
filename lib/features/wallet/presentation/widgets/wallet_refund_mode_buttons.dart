import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_refund_mode_button.dart';

class WalletRefundModeButtons extends StatelessWidget {
  const WalletRefundModeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return IconTheme(
      data: IconThemeData(color: color.primary),
      child: Row(
        children: [
          Expanded(
            child: WalletRefundModeButton(
              label: locale.wallet_refund_custom_amount,
              icon: Icons.edit_rounded,
            ),
          ),
          const SizedBox(width: Spacing.lg),
          Expanded(
            child: WalletRefundModeButton(
              label: locale.wallet_refund_full_balance,
              icon: Icons.account_balance_wallet_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
