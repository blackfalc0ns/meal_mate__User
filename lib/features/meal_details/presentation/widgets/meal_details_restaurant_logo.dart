import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class MealDetailsRestaurantLogo extends StatelessWidget {
  const MealDetailsRestaurantLogo({
    super.key,
    required this.label,
    required this.size,
    this.logoUrl,
  });

  final String label;
  final double size;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color.primary, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: logoUrl == null || logoUrl!.isEmpty
          ? Text(
              label,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.onPrimary,
              ).copyWith(height: locale.localeName == 'ar' ? 1 : 0.95),
            )
          : ClipOval(
              child: AppCachedNetworkImage(
                imageUrl: logoUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                semanticLabel: label,
              ),
            ),
    );
  }
}
