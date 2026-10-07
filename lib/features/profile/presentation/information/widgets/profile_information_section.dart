import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileInformationSection extends StatelessWidget {
  const ProfileInformationSection({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            title,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          SelectableText(
            body,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
