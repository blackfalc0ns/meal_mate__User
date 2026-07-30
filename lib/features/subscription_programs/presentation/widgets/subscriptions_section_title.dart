import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionsSectionTitle extends StatelessWidget {
  const SubscriptionsSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.screenH,
        top: Spacing.screenV,
        bottom: Spacing.base,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size20,
            color: color.onSurface,
          ),
        ),
      ),
    );
  }
}
