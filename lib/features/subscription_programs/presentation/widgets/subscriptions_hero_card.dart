import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionsHeroCard extends StatelessWidget {
  const SubscriptionsHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.subscriptionHeroHeight,
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.xxl),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            end: 6,
            bottom: 14,
            child: SizedBox(
              width: 134,
              height: 103,
              child: Image.asset(
                AssetsFake.subscriptionHeroMeal,
                fit: BoxFit.contain,
              ),
            ),
          ),
          PositionedDirectional(
            start: 12,
            top: 16,
            bottom: 16,
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size24,
                    color: color.tertiary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  //textAlign: TextAlign.left,
                  style: getRegularStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size16,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Dot(isActive: true),
                const SizedBox(width: Spacing.sm),
                _Dot(),
                const SizedBox(width: Spacing.sm),
                _Dot(),
                const SizedBox(width: Spacing.sm),
                _Dot(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: isActive ? 24 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive
            ? color.tertiaryContainer
            : color.tertiaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(Spacing.xs),
      ),
    );
  }
}
