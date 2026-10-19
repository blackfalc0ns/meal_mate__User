import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/models/family_restaurants_view_data.dart';

class FamilyRestaurantLogo extends StatelessWidget {
  const FamilyRestaurantLogo({super.key, required this.restaurant});

  final FamilyRestaurantCardData restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    if (restaurant.logoUrl != null &&
        restaurant.logoUrl!.isNotEmpty &&
        (restaurant.logoUrl!.startsWith('http://') ||
            restaurant.logoUrl!.startsWith('https://'))) {
      return Container(
        width: Spacing.familyRestaurantsLogoSize,
        height: Spacing.familyRestaurantsLogoSize,
        decoration: BoxDecoration(
          color: color.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: 0.6),
            width: Spacing.border,
          ),
        ),
        child: ClipOval(
          child: AppCachedNetworkImage(
            imageUrl: restaurant.logoUrl,
            width: Spacing.familyRestaurantsLogoSize,
            height: Spacing.familyRestaurantsLogoSize,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Container(
      width: Spacing.familyRestaurantsLogoSize,
      height: Spacing.familyRestaurantsLogoSize,
      decoration: BoxDecoration(
        color: color.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.6),
          width: Spacing.border,
        ),
      ),
      child: Center(child: _buildBrandContent(context)),
    );
  }

  Widget _buildBrandContent(BuildContext context) {
    final color = context.colorScheme;
    final name = restaurant.name;

    if (name.contains('سلاد') || name.toLowerCase().contains('salad')) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(text: 'S', style: _logoStyle(context, color.onSurface)),
            TextSpan(text: 'A', style: _logoStyle(context, color.primary)),
            TextSpan(text: 'L', style: _logoStyle(context, color.onSurface)),
            TextSpan(text: 'A', style: _logoStyle(context, color.primary)),
            TextSpan(text: 'D\n', style: _logoStyle(context, color.onSurface)),
            TextSpan(text: 'ST', style: _logoStyle(context, color.onSurface)),
            TextSpan(text: 'A', style: _logoStyle(context, color.primary)),
            TextSpan(text: 'TI', style: _logoStyle(context, color.onSurface)),
            TextSpan(text: 'O', style: _logoStyle(context, color.primary)),
            TextSpan(text: 'N', style: _logoStyle(context, color.onSurface)),
          ],
        ),
      );
    }

    if (name.contains('دايت') || name.toLowerCase().contains('diet')) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('DIET', style: _logoStyle(context, color.onSurface)),
              const SizedBox(width: Spacing.xxs),
              Icon(
                Icons.eco_rounded,
                color: color.primary,
                size: Spacing.iconXs,
              ),
            ],
          ),
          Text('HOUSE', style: _logoStyle(context, color.onSurface)),
        ],
      );
    }

    if (name.contains('هيلثي') || name.toLowerCase().contains('healthy')) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('HEALTHY', style: _logoStyle(context, color.primary)),
          Text('BOWL', style: _logoStyle(context, color.onSurface)),
        ],
      );
    }

    if (name.contains('بروتين') || name.toLowerCase().contains('protein')) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'THE',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size6,
              color: color.onSurfaceVariant,
            ).copyWith(height: 0.9),
          ),
          Text('PROTEIN', style: _logoStyle(context, color.onSurface)),
          Text('KITCHEN', style: _logoStyle(context, color.onSurface)),
        ],
      );
    }

    final words = name.split(' ');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          words.first.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _logoStyle(context, color.onSurface),
        ),
        if (words.length > 1)
          Text(
            words[1].toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _logoStyle(context, color.onSurface),
          ),
      ],
    );
  }

  TextStyle _logoStyle(BuildContext context, Color textColor) {
    return getBoldStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: FontSize.size8,
      color: textColor,
    ).copyWith(height: 1.05);
  }
}
