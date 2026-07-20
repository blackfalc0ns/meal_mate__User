import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionProgramHeader extends StatelessWidget {
  const SubscriptionProgramHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SizedBox(
        width: Spacing.subscriptionProgramsHeaderWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.subscription_program_title,
              textAlign: TextAlign.right,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size22,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              locale.subscription_program_subtitle,
              textAlign: TextAlign.right,
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
