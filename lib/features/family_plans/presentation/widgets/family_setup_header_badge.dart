import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilySetupHeaderBadge extends StatelessWidget {
  const FamilySetupHeaderBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: Spacing.base),
      child: Container(
        width: Spacing.familyProgramHeaderActionWidth,
        height: Spacing.familyProgramHeaderActionHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(color: color.outlineVariant),
          borderRadius: BorderRadius.circular(Spacing.xss),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.10),
              blurRadius: Spacing.xs,
              offset: const Offset(0, Spacing.xs),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Icon(Icons.group_rounded, size: Spacing.md, color: color.primary),
                      const SizedBox(width: Spacing.xs),

           Text(
              locale.family_header_badge,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.onSurface,
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
