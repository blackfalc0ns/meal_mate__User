import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionRestaurantLogoStack extends StatelessWidget {
  const SubscriptionRestaurantLogoStack({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: Spacing.xxxl * 2.45,
      height: Spacing.xxl,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            end: 0,
            child: Container(
              width: Spacing.xxl,
              height: Spacing.xxl,
              decoration: BoxDecoration(
                color: color.surface,
                shape: BoxShape.circle,
                border: Border.all(color: color.primary),
              ),
              child: ClipOval(
                child: Image.asset(
                  AssetsFake.burgerKingLogo,
                  fit: BoxFit.cover,
                  semanticLabel: locale.nav_subscription,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            end: Spacing.lg,
            child: Container(
              width: Spacing.xxl,
              height: Spacing.xxl,
              decoration: BoxDecoration(
                color: color.surface,
                shape: BoxShape.circle,
                border: Border.all(color: color.primary),
              ),
              child: ClipOval(
                child: Image.asset(
                  AssetsFake.mcdonaldsLogo,
                  fit: BoxFit.cover,
                  semanticLabel: locale.nav_subscription,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            end: Spacing.lg * 2,
            child: Container(
              width: Spacing.xxl,
              height: Spacing.xxl,
              decoration: BoxDecoration(
                color: color.surface,
                shape: BoxShape.circle,
                border: Border.all(color: color.primary),
              ),
              child: ClipOval(
                child: Image.asset(
                  AssetsFake.starbucksLogo,
                  fit: BoxFit.cover,
                  semanticLabel: locale.nav_subscription,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            end: Spacing.lg * 3,
            child: Container(
              width: Spacing.xxl,
              height: Spacing.xxl,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.surface,
                shape: BoxShape.circle,
                border: Border.all(color: color.primary),
              ),
              child: Text(
                '+25',
                textDirection: TextDirection.ltr,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size8,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
