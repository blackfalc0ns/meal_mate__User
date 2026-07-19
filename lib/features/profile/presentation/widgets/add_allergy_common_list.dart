import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddAllergyCommonList extends StatelessWidget {
  const AddAllergyCommonList({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onToggle,
  });

  final List<String> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.addAllergyPopularHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Spacing.addAllergyPopularRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.07),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: Spacing.addAllergyPopularRowHeight,
            child: Row(
              children: [
                SvgPicture.asset(
                  AssetsFake.addAllergyPopular,
                  width: Spacing.lg,
                  height: Spacing.lg,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.add_allergy_common_allergies,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ),
          ...options.map(
            (option) => Expanded(
              child: InkWell(
                onTap: () => onToggle(option),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size11,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                    selectedOptions.contains(option)
                        ? SvgPicture.asset(
                            AssetsFake.addAllergyChecked,
                            width: Spacing.dietaryIconSize,
                            height: Spacing.dietaryIconSize,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            size: Spacing.dietaryIconSize,
                            color: color.outline,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
