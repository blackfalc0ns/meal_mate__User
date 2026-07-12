import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';

class CalendarRestaurantSummaryCard extends StatelessWidget {
  const CalendarRestaurantSummaryCard({
    super.key,
    required this.restaurant,
    required this.onMorePressed,
  });

  final CalendarRestaurantEntity restaurant;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.brandDeepGreen,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandDeepGreen.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            top: 15,
            bottom: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RestaurantTextBlock(restaurant: restaurant),
                const SizedBox(width: 14),
                const _RestaurantLogo(),
              ],
            ),
          ),
          PositionedDirectional(
            bottom: 15,
            start: 25,
            end: 25,
            child: SizedBox(
              height: 21,
              child: FilledButton.icon(
                onPressed: onMorePressed,
                icon: Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.brandDeepGreen,
                  size: 12,
                ),
                label: const Text('تغيير المطعم'),
                style: FilledButton.styleFrom(
                  backgroundColor: color.surface,
                  foregroundColor: AppColors.brandDeepGreen,
                  padding: EdgeInsets.zero,
                  textStyle: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 8.6,
                    color: AppColors.brandDeepGreen,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantTextBlock extends StatelessWidget {
  const _RestaurantTextBlock({required this.restaurant});

  final CalendarRestaurantEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.verified_rounded, color: color.onPrimary, size: 13),
              const SizedBox(width: 4),
              Text(
                restaurant.name,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 11.7,
                  color: color.onPrimary,
                ).copyWith(letterSpacing: 0),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            restaurant.category,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8.5,
              color: color.onPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _MetaChip(icon: Icons.star_rounded, label: restaurant.rating),
              const SizedBox(width: 10),
              _MetaChip(
                icon: Icons.access_time_rounded,
                label: restaurant.deliveryDuration,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            restaurant.deliveryWindow,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8.5,
              color: color.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: 8.5,
            color: color.onPrimary,
          ),
        ),
        const SizedBox(width: 2),
        Icon(icon, color: color.onPrimary, size: 10),
      ],
    );
  }
}

class _RestaurantLogo extends StatelessWidget {
  const _RestaurantLogo();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 58,
      height: 54,
      decoration: BoxDecoration(color: color.surface, shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.ramen_dining_rounded,
            color: AppColors.brandDeepGreen,
            size: 22,
          ),
          Text(
            'HEALTHY',
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 7.5,
              color: AppColors.calendarAccentDark,
            ).copyWith(height: 1),
          ),
          Text(
            'BOWL',
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 7.5,
              color: AppColors.calendarAccentDark,
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
