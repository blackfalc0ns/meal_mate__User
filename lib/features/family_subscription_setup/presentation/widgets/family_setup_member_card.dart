import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilySetupMemberCard extends StatelessWidget {
  const FamilySetupMemberCard({
    super.key,
    required this.name,
    required this.imageAsset,
    this.isSelected = false,
    this.onTap,
  });

  final String name;
  final String imageAsset;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  imageAsset,
                  width: Spacing.familySetupMemberAvatarSize,
                  height: Spacing.familySetupMemberAvatarSize,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xss),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: Spacing.xs,
                          height: Spacing.xs,
                          decoration: BoxDecoration(
                            color: color.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: Spacing.xss),
                        Text(
                          locale.family_member_completed,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size6,
                            color: color.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
