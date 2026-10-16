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
    final cardBorderRadius = BorderRadius.circular(Spacing.base);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: cardBorderRadius,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: Spacing.familyProgramCardHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color:
                    // isSelected
                    //  ? color.primaryContainer.withValues(alpha: 0.08)
                    //  :
                    color.surface,
                borderRadius: cardBorderRadius,
                border: Border.all(
                  color: isSelected ? color.primary : color.outlineVariant,
                  width: isSelected
                      ? Spacing.familySelectedBorderWidth
                      : Spacing.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.04),
                    blurRadius: Spacing.sm,
                    offset: const Offset(0, Spacing.xxs),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Spacing.sm,
                          ),
                          child: Text(
                            program.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.xxs),
                        Text(
                          program.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurfaceVariant,
                          ).copyWith(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  AppCachedNetworkImage(
                    imageUrl: program.imageAsset,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    semanticLabel: program.title,
                  ),
                ],
              ),
            ),
            if (isSelected)
              PositionedDirectional(
                top: -Spacing.xs,
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
