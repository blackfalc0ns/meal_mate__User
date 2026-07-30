import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomePromotionCard extends StatelessWidget {
  const HomePromotionCard({super.key, required this.buttonLabel});
  final String buttonLabel;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return SizedBox(
      height: Spacing.homePromotionHeight,
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: [
            PositionedDirectional(
              end: 0,
              child: Image.asset(
                Assets.homePromotion,
                height: Spacing.homePromotionHeight,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'خصم 30%',
                    style: AppTextStyles.h3.copyWith(color: color.primary),
                  ),
                  Text(
                    'على جميع الاشتراكات',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  SizedBox(
                    height: Spacing.buttonSmallHeight,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(buttonLabel),
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
