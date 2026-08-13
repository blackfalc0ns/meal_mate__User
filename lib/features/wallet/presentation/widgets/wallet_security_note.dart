import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletSecurityNote extends StatelessWidget {
  const WalletSecurityNote({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user_rounded,
          size: Spacing.walletSecurityIconSize,
          color: color.onSurfaceVariant,
        ),
        const SizedBox(width: Spacing.sm),
        Flexible(
          child: Text(
            locale.wallet_security_note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
