import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealMateDrawerProfileHeader extends StatelessWidget {
  const MealMateDrawerProfileHeader({
    super.key,
    required this.animationValue,
    required this.userName,
    required this.greeting,
    required this.avatarAsset,
    required this.planLabel,
    required this.packageLabel,
  });

  final double animationValue;
  final String userName;
  final String greeting;
  final String avatarAsset;
  final String planLabel;
  final String packageLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final curved = Curves.easeOutBack.transform(animationValue.clamp(0.0, 1.0));
    final textSlide = (1 - animationValue) * 22;
    final avatarSlide = (1 - animationValue) * 18;

    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Opacity(
          opacity: (animationValue * 1.8).clamp(0.0, 1.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(avatarSlide, 0),
                child: Transform.scale(
                  scale: 0.82 + (0.18 * curved),
                  child: MealMateDrawerAvatar(asset: avatarAsset, size: 63),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 94,
                child: Transform.translate(
                  offset: Offset(textSlide, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (greeting.isNotEmpty) ...[
                        Text(
                          greeting,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size13,
                            color: color.onPrimary.withValues(alpha: 0.96),
                          ),
                        ),
                        const SizedBox(height: 1),
                      ],
                      Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size14,
                          color: color.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Opacity(
                        opacity: ((animationValue - 0.45) / 0.55).clamp(
                          0.0,
                          1.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MealMateDrawerProfileMetaRow(
                              icon: Icons.eco_rounded,
                              label: planLabel,
                              iconSize: 12,
                            ),
                            const SizedBox(height: 3),
                            MealMateDrawerProfileMetaRow(
                              icon: Icons.workspace_premium_rounded,
                              label: packageLabel,
                              iconSize: 14,
                            ),
                          ],
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
    );
  }
}

class MealMateDrawerAvatar extends StatelessWidget {
  const MealMateDrawerAvatar({super.key, required this.asset, this.size = 67});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.onPrimary.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(4),
      child: ClipOval(
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return ColoredBox(
              color: color.onPrimary,
              child: Icon(Icons.person, color: color.primary, size: 42),
            );
          },
        ),
      ),
    );
  }
}

class MealMateDrawerProfileMetaRow extends StatelessWidget {
  const MealMateDrawerProfileMetaRow({
    super.key,
    required this.icon,
    required this.label,
    required this.iconSize,
  });

  final IconData icon;
  final String label;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      textDirection: ui.TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color.inversePrimary, size: iconSize),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size10,
              color: color.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
