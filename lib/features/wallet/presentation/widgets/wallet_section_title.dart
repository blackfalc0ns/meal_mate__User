import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletSectionTitle extends StatelessWidget {
  const WalletSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return Row(
      children: [
        const Spacer(),
        Text(
          title,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size16,
            color: color.onSurface,
          ),
        ),
      ],
    );
  }
}
