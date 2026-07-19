import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddAllergySummaryCard extends StatelessWidget {
  const AddAllergySummaryCard({super.key, required this.selectedAllergies});

  final List<String> selectedAllergies;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: Spacing.addAllergySummaryHeight,
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: color.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(Spacing.addAllergySummaryRadius),
        ),
        child: Row(
          children: [
            Container(
              width: Spacing.addAllergySummaryCountSize,
              height: Spacing.addAllergySummaryCountSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedAllergies.length.toString(),
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size16,
                      color: color.primary,
                    ),
                  ),
                  Text(
                    locale.add_allergy_selected,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size9,
                      color: color.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.add_allergy_current_allergies,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size11,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.sm,
                    children: selectedAllergies
                        .map(
                          (allergy) => Container(
                            width: Spacing.addAllergySummaryChipWidth,
                            height: Spacing.addAllergySummaryChipHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color.primary,
                              borderRadius: BorderRadius.circular(
                                Spacing.addAllergySummaryRadius,
                              ),
                            ),
                            child: Text(
                              allergy,
                              style: getMediumStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size13,
                                color: color.onPrimary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
