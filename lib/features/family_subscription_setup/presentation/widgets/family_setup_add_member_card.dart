import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilySetupAddMemberCard extends StatelessWidget {
  const FamilySetupAddMemberCard({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Spacing.familySetupMemberCardHeight,
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(
            color: isSelected ? color.primary : color.outlineVariant,
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(
            Spacing.familySetupMemberCardRadius,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Spacing.familySetupAddIconSize,
              height: Spacing.familySetupAddIconSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? color.primary
                      : color.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                color: color.primary,
                size: Spacing.iconSm,
              ),
            ),
            const SizedBox(height: Spacing.xss),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size8,
                color: isSelected ? color.primary : color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
