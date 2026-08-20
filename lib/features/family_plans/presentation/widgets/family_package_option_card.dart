import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';

class FamilyPackageOptionCard extends StatelessWidget {
  const FamilyPackageOptionCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  final FamilyPackageOptionUiModel option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final selected = option.isSelected;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.familyProgramCardRadius),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: Spacing.familyPackageOptionHeight,
            // padding: const EdgeInsets.symmetric(
            //   horizontal: Spacing.sm,
            //   vertical: Spacing.sm,
            // ),
            decoration: BoxDecoration(
              color: color.surface,
              border: Border.all(
                color: selected ? color.primary : color.outlineVariant,
                width: selected
                    ? Spacing.familySelectedBorderWidth
                    : Spacing.border,
              ),
              borderRadius: BorderRadius.circular(
                Spacing.familyProgramCardRadius,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: AppCachedNetworkImage(
                      imageUrl: option.imageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      backgroundColor: color.surface.withValues(alpha: 0),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.xss),
                Text(
                  option.title,
                  maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xss),
                Text(
                  option.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            PositionedDirectional(
              top: -Spacing.md,
              end: -Spacing.xs,
              child: CircleAvatar(
                radius: Spacing.sm,
                backgroundColor: color.primary,
                child: Icon(
                  Icons.check_rounded,
                  size: Spacing.iconSm,
                  color: color.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
