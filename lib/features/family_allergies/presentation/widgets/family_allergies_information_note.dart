import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
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
        color: color.familyAllergiesSelectedBg,
        borderRadius: BorderRadius.circular(
          Spacing.familyAllergiesNoticeRadius,
        ),
        border: Border.all(color: color.familyAllergiesSelectedPrimary),
      ),
      child: Row(
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: Spacing.iconMd,
            color: color.familyAllergiesSelectedPrimary,
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: AppColors.addressesPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
