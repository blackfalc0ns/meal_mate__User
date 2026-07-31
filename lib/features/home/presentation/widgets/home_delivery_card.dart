import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeDeliveryCard extends StatelessWidget {
  const HomeDeliveryCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.action,
  });

  final String image;
  final String title;
  final String subtitle;
  final String action;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Semantics(
      label: locale.home_subscription_details,
      child: Card(
        color: color.primaryContainer,
        child: Stack(
          children: [
            PositionedDirectional(
              end: Spacing.homePromotionImageEnd,
              child: Image.asset(image, height: Spacing.homeInfoCardHeight),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: color.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    action,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: color.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
