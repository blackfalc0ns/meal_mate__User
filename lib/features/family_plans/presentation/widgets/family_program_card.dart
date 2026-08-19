import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';

class FamilyProgramCard extends StatelessWidget {
  const FamilyProgramCard({
    super.key,
    required this.program,
    required this.isSelected,
    required this.onTap,
    required this.borderColor,
    required this.semanticPrefix,
  });

  final FamilyProgramUiModel program;
  final bool isSelected;
  final VoidCallback onTap;
  final Color borderColor;
  final String semanticPrefix;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Material(
      color: color.surface.withValues(alpha: 0),
      borderRadius: BorderRadius.circular(
        isSelected
            ? Spacing.familyProgramCardSelectedRadius
            : Spacing.familyProgramCardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          isSelected
              ? Spacing.familyProgramCardSelectedRadius
              : Spacing.familyProgramCardRadius,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: Spacing.familyProgramCardHeight,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              decoration: BoxDecoration(
                color: color.surface,
                border: Border.all(
                  color: isSelected ? borderColor : color.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(
                  isSelected
                      ? Spacing.familyProgramCardSelectedRadius
                      : Spacing.familyProgramCardRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.10),
                    blurRadius: Spacing.xs,
                    offset: const Offset(0, Spacing.xs),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          program.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          program.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurfaceVariant,
                          ).copyWith(height: 1.45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  if (program.imageAsset.startsWith('http'))
                    Image.network(
                      program.imageAsset,
                      width: Spacing.familyProgramImageSize,
                      height: Spacing.familyProgramImageSize,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, _, _) => Icon(
                            Icons.restaurant_rounded,
                            color: color.primary,
                            size: Spacing.familyProgramImageSize,
                          ),
                    )
                  else if (program.imageAsset.isNotEmpty)
                    Image.asset(
                      program.imageAsset,
                      width: Spacing.familyProgramImageSize,
                      height: Spacing.familyProgramImageSize,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, _, _) => Icon(
                            Icons.restaurant_rounded,
                            color: color.primary,
                            size: Spacing.familyProgramImageSize,
                          ),
                    )
                  else
                    Icon(
                      Icons.restaurant_rounded,
                      color: color.primary,
                      size: Spacing.familyProgramImageSize,
                    ),
                ],
              ),
            ),
            if (isSelected)
              PositionedDirectional(
                top: -Spacing.sm,
                end: -Spacing.xs,
                child: Container(
                  width: Spacing.familyProgramCheckSize,
                  height: Spacing.familyProgramCheckSize,
                  decoration: BoxDecoration(
                    color: color.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: color.onPrimary,
                    size: Spacing.iconSm,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
