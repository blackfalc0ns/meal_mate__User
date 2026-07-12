import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

class CalendarRestaurantPickerSheet extends StatelessWidget {
  const CalendarRestaurantPickerSheet({
    super.key,
    required this.restaurants,
    required this.onRestaurantSelected,
  });

  final List<CalendarRestaurantOptionEntity> restaurants;
  final ValueChanged<CalendarRestaurantOptionEntity> onRestaurantSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.75,
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: const Color(0xFFAFAFAF), width: 0.8),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 11,
              left: 17,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 25,
                  height: 25,
                ),
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: Color(0xFFB5B4B4),
                  size: 25,
                ),
              ),
            ),
            Positioned(
              top: 11,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 31,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB5B4B4),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'استعراض المطاعم',
                    textAlign: TextAlign.center,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: 14,
                      color: color.onSurface,
                    ).copyWith(height: 20 / 14, letterSpacing: 0),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: getRegularStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 10,
                        color: color.onSurface.withValues(alpha: 0.64),
                      ).copyWith(height: 2, letterSpacing: 0),
                      children: [
                        const TextSpan(text: 'اختر المطعم الذي تفضله ليوم '),
                        TextSpan(
                          text: 'السبت 20 سبتمبر',
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: 10,
                            color: AppColors.primaryVariant,
                          ).copyWith(height: 2, letterSpacing: 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 87,
              left: 42,
              right: 42,
              child: _RestaurantSearchField(),
            ),
            Positioned(
              top: 149,
              left: 19,
              right: 20,
              bottom: 24,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: restaurants.length,
                separatorBuilder: (_, _) => const SizedBox(height: 9.2),
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return _RestaurantOptionCard(
                    restaurant: restaurant,
                    onTap: () => onRestaurantSelected(restaurant),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantSearchField extends StatelessWidget {
  const _RestaurantSearchField();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: 35,
      padding: const EdgeInsetsDirectional.fromSTEB(13, 0, 13, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(17.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: color.onSurface.withValues(alpha: 0.62),
            size: 22,
          ),
          Expanded(
            child: Text(
              'ابحث عن مطعم أو نوع مطبخ...',
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: 13,
                color: color.onSurface.withValues(alpha: 0.62),
              ).copyWith(height: 20 / 13),
            ),
          ),
          const SizedBox(width: 22),
        ],
      ),
    );
  }
}

class _RestaurantOptionCard extends StatelessWidget {
  const _RestaurantOptionCard({required this.restaurant, required this.onTap});

  final CalendarRestaurantOptionEntity restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 74.22,
      child: Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(15.46),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.46),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.46),
              border: Border.all(color: const Color(0xFFF6F6F7), width: 1.55),
            ),
            padding: const EdgeInsets.fromLTRB(7.4, 4.6, 7.4, 4.8),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                const _ArrowBubble(),
                const SizedBox(width: 27.6),
                _Rating(value: restaurant.rating),
                const SizedBox(width: 27.6),
                Expanded(child: _RestaurantCopy(restaurant: restaurant)),
                const SizedBox(width: 10.5),
                _RestaurantLogo(type: restaurant.logoType),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowBubble extends StatelessWidget {
  const _ArrowBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.74,
      height: 24.74,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F6F7),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.black,
        size: 15,
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: 38,
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFF0C8F49), size: 13),
          const SizedBox(width: 4),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 10.96,
              color: color.onSurface,
            ).copyWith(letterSpacing: 0),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCopy extends StatelessWidget {
  const _RestaurantCopy({required this.restaurant});

  final CalendarRestaurantOptionEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            restaurant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 11.79,
              color: color.onSurface,
            ).copyWith(letterSpacing: 0),
          ),
          const SizedBox(height: 1.8),
          Text(
            restaurant.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8.5,
              color: const Color(0xFF737376),
            ).copyWith(letterSpacing: 0),
          ),
          const SizedBox(height: 1.8),
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: 10.96,
                color: color.onSurface,
              ).copyWith(letterSpacing: 0),
              children: [
                TextSpan(
                  text: '${restaurant.mealCount}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: ' وجبة'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantLogo extends StatelessWidget {
  const _RestaurantLogo({required this.type});

  final CalendarRestaurantLogoType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CalendarRestaurantLogoType.healthyBowl:
        return const _CircleTextLogo(
          top: 'HEALTHY',
          bottom: 'BOWL',
          icon: Icons.ramen_dining_rounded,
          foreground: Color(0xFF28791F),
          outlined: true,
        );
      case CalendarRestaurantLogoType.dietHouse:
        return const _CircleTextLogo(
          top: 'DIET',
          bottom: 'HOUSE',
          icon: Icons.eco_rounded,
          foreground: Colors.black,
          outlined: true,
        );
      case CalendarRestaurantLogoType.proteinKitchen:
        return const _CircleTextLogo(
          eyebrow: 'THE',
          top: 'PROTEIN',
          bottom: 'KITCHEN',
          foreground: Colors.white,
          background: Colors.black,
        );
      case CalendarRestaurantLogoType.starbucks:
        return const _ImageCircleLogo(asset: Assets.offerStarbucksLogo);
      case CalendarRestaurantLogoType.burgerKing:
        return const _ImageCircleLogo(asset: Assets.offerBurgerKingLogo);
    }
  }
}

class _CircleTextLogo extends StatelessWidget {
  const _CircleTextLogo({
    required this.top,
    required this.bottom,
    required this.foreground,
    this.eyebrow,
    this.icon,
    this.background = Colors.white,
    this.outlined = false,
  });

  final String? eyebrow;
  final String top;
  final String bottom;
  final IconData? icon;
  final Color foreground;
  final Color background;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.7,
      height: 64.7,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: outlined
            ? Border.all(color: const Color(0xFFF6F6F7), width: 2.1)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: foreground, size: 27)
          else if (eyebrow != null)
            Text(eyebrow!, style: _logoStyle(9.5, foreground)),
          Text(top, style: _logoStyle(icon == null ? 10 : 11.6, foreground)),
          Text(bottom, style: _logoStyle(icon == null ? 10 : 11.6, foreground)),
        ],
      ),
    );
  }

  TextStyle _logoStyle(double size, Color color) {
    return TextStyle(
      fontFamily: FontConstant.ibmPlexSansArabic,
      fontWeight: FontWeight.w700,
      fontSize: size,
      height: 0.95,
      color: color,
    );
  }
}

class _ImageCircleLogo extends StatelessWidget {
  const _ImageCircleLogo({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(asset, width: 59.9, height: 59.9, fit: BoxFit.contain),
    );
  }
}
