import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_icon.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_price.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_tier_logos_row.dart';

class RestaurantPackageTierCard extends StatelessWidget {
  const RestaurantPackageTierCard({
    super.key,
    required this.package,
    required this.title,
    required this.width,
    required this.height,
    required this.isCentered,
    required this.isSelected,
    required this.onTap,
    required this.onBrowseRestaurants,
  });

  final RestaurantPackageTierUiModel package;
  final String title;
  final double width;
  final double height;
  final bool isCentered;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isFeatured = isCentered;
    final lower = package.iconName.toLowerCase();
    final tierLower = package.id?.toLowerCase() ?? '';
    final titleLower = title.toLowerCase();

    final isMax =
        lower.contains('max') ||
        lower.contains('diamond') ||
        lower.contains('elite') ||
        tierLower.contains('max') ||
        tierLower.contains('elite') ||
        titleLower.contains('max') ||
        titleLower.contains('elite') ||
        title.contains('ماكس') ||
        title.contains('إيليت');

    final isPlus =
        !isMax &&
        (isFeatured ||
            lower.contains('plus') ||
            lower.contains('crown') ||
            lower.contains('platinum') ||
            tierLower.contains('plus') ||
            tierLower.contains('platinum') ||
            titleLower.contains('plus') ||
            titleLower.contains('platinum') ||
            title.contains('بلس') ||
            title.contains('بلاتينيوم'));

    final isAr = locale.localeName == 'ar';
    final String resolvedTitle = title.trim().isNotEmpty
        ? title.trim()
        : package.title.trim();
    final String displayTitle = resolvedTitle.isNotEmpty
        ? resolvedTitle
        : (isMax
            ? (isAr ? 'ماكس' : 'Max')
            : isPlus
                ? (isAr ? 'بلس' : 'Plus')
                : (isAr ? 'سيلكت' : 'Select'));

    final countLabel = package.restaurantCount > 0
        ? '+${package.restaurantCount}'
        : '';

    final List<Color> cardGradient = isPlus
        ? const [Color(0xFF0D986A), Color(0xFF087A4D)]
        : isMax
        ? const [Color(0xFF26282B), Color(0xFF1B1C1E)]
        : [color.surface, color.surface];

    final Color borderColor = isPlus
        ? const Color(0xFF0D986A)
        : isMax
        ? const Color(0xFF33353A)
        : color.outlineVariant;

    final Color shadowColor = isPlus
        ? const Color(0x38057241)
        : isMax
        ? const Color(0x40000000)
        : isSelected
        ? color.primary.withValues(alpha: 0.15)
        : color.shadow.withValues(alpha: 0.08);

    final Color titleColor = isPlus
        ? color.onPrimary
        : isMax
        ? const Color(0xFFCCA054)
        : color.primary;

    final Color buttonBackgroundColor = isPlus
        ? color.surface
        : isMax
        ? const Color(0xFFCCA054)
        : color.primary;

    final Color buttonForegroundColor = isPlus
        ? const Color(0xFF0D986A)
        : color.onPrimary;

    final Color priceColor = isPlus
        ? color.onPrimary
        : isMax
        ? color.onPrimary
        : color.primary;

    final Color priceSubtitleColor = isPlus
        ? color.onPrimary.withValues(alpha: 0.85)
        : isMax
        ? color.onPrimary.withValues(alpha: 0.75)
        : color.primary.withValues(alpha: 0.85);

    final Color dividerColor = isPlus
        ? color.onPrimary.withValues(alpha: 0.35)
        : isMax
        ? color.onPrimary.withValues(alpha: 0.25)
        : color.primary.withValues(alpha: 0.35);

    return Semantics(
      button: true,
      selected: isSelected,
      label: displayTitle,
      child: SizedBox(
        width: width,
        height: height,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (package.canSelect && package.isAvailable) ? onTap : null,
          child: CustomPaint(
            painter: _RestaurantPackageTierCardPainter(
              colors: cardGradient,
              borderColor: borderColor,
              shadowColor: shadowColor,
              radius: Spacing.monthlyPlanPackageSideRadius,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: Spacing.monthlyPlanPackageLogoStart,
                    top: Spacing.monthlyPlanPackageLogoTop,
                    child: RestaurantTierLogosRow(
                      countLabel: countLabel,
                      logoUrls: package.restaurantLogoUrls,
                      isFeatured: isPlus,
                    ),
                  ),
                  Positioned(
                    right: Spacing.monthlyPlanPackageIndicatorEnd,
                    top: Spacing.monthlyPlanPackageIndicatorTop,
                    child: IgnorePointer(
                      child: Container(
                        width: Spacing.monthlyPlanPackageIndicatorSize,
                        height: Spacing.monthlyPlanPackageIndicatorSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? color.primary : color.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? color.primary
                                : color.outlineVariant,
                            width: Spacing.border,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.shadow.withValues(alpha: 0.12),
                              blurRadius: Spacing.xs,
                              offset: const Offset(0, Spacing.hairline),
                            ),
                          ],
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                size: Spacing.iconSm,
                                color: color.onPrimary,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    left: Spacing.monthlyPlanPackageLogoStart,
                    right: Spacing.sm,
                    top: Spacing.monthlyPlanPackageTitleTop,
                    bottom: Spacing.sm,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RestaurantPackageTierPrice(
                          price: package.price,
                          currency: package.currency,
                          priceSubtitle: package.priceSubtitle,
                          priceColor: priceColor,
                          subtitleColor: priceSubtitleColor,
                          dividerColor: dividerColor,
                          isLoading: package.isPriceLoading,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onBrowseRestaurants,
                              child: Container(
                                height: Spacing.monthlyPlanPackageButtonHeight,
                                constraints: const BoxConstraints(
                                  maxWidth: 122.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: buttonBackgroundColor,
                                  borderRadius: BorderRadius.circular(
                                    Spacing.radiusPill,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.shadow.withValues(
                                        alpha: 0.10,
                                      ),
                                      blurRadius: Spacing.xs,
                                      offset: const Offset(0, Spacing.hairline),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chevron_left_rounded,
                                      size: Spacing.iconSm,
                                      color: buttonForegroundColor,
                                    ),
                                    // const SizedBox(width: Spacing.xxs),
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          locale.calendar_browse_restaurants,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: getBoldStyle(
                                            fontFamily: FontConstant.alexandria,
                                            fontSize: FontSize.size10,
                                            color: buttonForegroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size20,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        RestaurantPackageTierIcon(
                          iconName: isMax
                              ? 'diamond'
                              : isPlus
                              ? 'crown'
                              : 'heart',
                          logoUrl: package.logoUrl,
                          usesLightForeground: isPlus || isMax,
                          isSelected: isSelected,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RestaurantPackageTierCardPainter extends CustomPainter {
  const _RestaurantPackageTierCardPainter({
    required this.colors,
    required this.borderColor,
    required this.shadowColor,
    required this.radius,
  });

  final List<Color> colors;
  final Color borderColor;
  final Color shadowColor;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createPath(size);
    canvas.drawShadow(path, shadowColor, Spacing.sm, true);

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = Spacing.hairline
      ..color = borderColor;

    canvas.drawPath(path, borderPaint);
  }

  Path _createPath(Size size) {
    const bodyTop = Spacing.monthlyPlanPackageBodyTop;
    final bodyBottom = size.height;
    final curveStart = size.width * 0.53;
    final curveWidth = size.width * 0.11;

    return Path()
      ..moveTo(radius, bodyTop)
      ..lineTo(curveStart, bodyTop)
      ..cubicTo(
        curveStart + curveWidth * 0.45,
        bodyTop,
        curveStart + curveWidth * 0.55,
        0,
        curveStart + curveWidth,
        0,
      )
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, bodyBottom - radius)
      ..quadraticBezierTo(
        size.width,
        bodyBottom,
        size.width - radius,
        bodyBottom,
      )
      ..lineTo(radius, bodyBottom)
      ..quadraticBezierTo(0, bodyBottom, 0, bodyBottom - radius)
      ..lineTo(0, bodyTop + radius)
      ..quadraticBezierTo(0, bodyTop, radius, bodyTop)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _RestaurantPackageTierCardPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.radius != radius;
  }
}
