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
    final cardBorderRadius = BorderRadius.circular(
      Spacing.familyProgramCardRadius,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: cardBorderRadius,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: Spacing.familyPackageOptionHeight,
            decoration: BoxDecoration(
              color: color.surface,
              border: Border.all(
                color: selected ? color.primary : color.outlineVariant,
                width: selected
                    ? Spacing.familySelectedBorderWidth
                    : Spacing.border,
              ),
              borderRadius: cardBorderRadius,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                Spacing.familyProgramCardRadius - 1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 72,
                    child: AppCachedNetworkImage(
                      imageUrl: option.imageUrl,
                      width: double.infinity,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs,
                        vertical: Spacing.xs,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            option.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
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
                              fontSize: FontSize.size8,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selected)
            PositionedDirectional(
              top: -Spacing.sm,
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
