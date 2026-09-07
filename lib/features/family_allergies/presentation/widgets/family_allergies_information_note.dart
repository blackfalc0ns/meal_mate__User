import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyAllergiesInformationNote extends StatelessWidget {
  const FamilyAllergiesInformationNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.familyAllergiesNoticeHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(
          Spacing.familyAllergiesNoticeRadius,
        ),
        border: Border.all(color: color.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: Spacing.iconLg,
            color: color.primary,
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
