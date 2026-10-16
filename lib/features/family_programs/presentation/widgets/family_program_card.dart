import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

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
        Spacing.familyProgramCardSelectedRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          Spacing.familyProgramCardSelectedRadius,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: Spacing.familyProgramCardHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  Spacing.familyProgramCardSelectedRadius,
                ),
                border: Border.all(
                  color: isSelected ? color.primary : color.onError,
                  width:
                      // isSelected
                      //     ? Spacing.familySelectedBorderWidth
                      // :
                      Spacing.border,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Spacing.sm),
                        Text(
                          program.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          program.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    child: AppCachedNetworkImage(
                      imageUrl: program.imageAsset,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      semanticLabel: program.title,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              PositionedDirectional(
                top: -Spacing.sm,
                start: -Spacing.xs,
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
