import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class MealDetailsHeaderImage extends StatelessWidget {
  const MealDetailsHeaderImage({super.key, required this.label, this.imageUrl});

  final String label;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final textDirection = locale.localeName == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Semantics(
      label: label,
      image: true,
      child: Directionality(
        textDirection: textDirection,
        child: SizedBox(
          height: Spacing.xxxl * 4 + Spacing.xxl,
          width: double.infinity,
          child: ClipRect(
            child: ColoredBox(
              color: color.surfaceContainerHighest,
              child: imageUrl == null || imageUrl!.isEmpty
                  ? Image.asset(
                      Assets.mealDetailsHero,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.2),
                      filterQuality: FilterQuality.medium,
                    )
                  : AppCachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      semanticLabel: label,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
