import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanPackagesSection extends StatelessWidget {
  const MonthlyPlanPackagesSection({
    super.key,
    required this.packages,
    required this.onBrowseRestaurants,
  });

  final List<MonthlyPackageTierEntity> packages;
  final VoidCallback onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 430).clamp(0.76, 1.0);

        return SizedBox(
          height: 228 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final package in packages)
                _PackageTierCard(
                  package: package,
                  scale: scale,
                  onBrowseRestaurants: onBrowseRestaurants,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PackageTierCard extends StatelessWidget {
  const _PackageTierCard({
    required this.package,
    required this.scale,
    required this.onBrowseRestaurants,
  });

  final MonthlyPackageTierEntity package;
  final double scale;
  final VoidCallback onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final isPopular = package.isPopular;

    return SizedBox(
      width: (isPopular ? 146 : 132) * scale,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: isPopular ? 0 : 21,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: (isPopular ? 146 : 132) * scale,
              height: (isPopular ? 227 : 206) * scale,
              padding: EdgeInsets.fromLTRB(
                8 * scale,
                isPopular ? 40 * scale : 14 * scale,
                8 * scale,
                8 * scale,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isPopular
                      ? const [
                          Color(0xB31B8E2F),
                          Color(0x4D1B8E2F),
                          Color(0x001B8E2F),
                        ]
                      : const [
                          Color(0xFFE5E5E5),
                          Color(0xB3FFFFFF),
                          Color(0x80FFFFFF),
                        ],
                  stops: const [0, 0.36, 0.65],
                ),
                border: Border.all(color: const Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(15.7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _PackageIcon(
                    icon: _iconFor(package.iconName),
                    package: package,
                  ),
                  SizedBox(height: 6 * scale),
                  Text(
                    package.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: 13 * scale,
                      color: color.onSurface,
                    ),
                  ),
                  Text(
                    package.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: 7 * scale,
                      color: AppColors.appTextMuted,
                    ),
                  ),
                  SizedBox(height: 10 * scale),
                  for (final bullet in package.bullets)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4 * scale),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 11,
                            color: AppColors.brandDeepGreen,
                          ),
                          SizedBox(width: 4 * scale),
                          Text(
                            bullet,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: 7.6 * scale,
                              color: color.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        package.period,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: 7.3 * scale,
                          color: AppColors.appTextMuted,
                        ),
                      ),
                      SizedBox(width: 3 * scale),
                      Text(
                        package.currency,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: 9 * scale,
                          color: color.onSurface,
                        ),
                      ),
                      SizedBox(width: 2 * scale),
                      Text(
                        package.price,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: 16 * scale,
                          color: AppColors.brandDeepGreen,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6 * scale),
                  InkWell(
                    onTap: onBrowseRestaurants,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    child: Container(
                      height: (isPopular ? 29 : 26) * scale,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        locale.calendar_browse_restaurants,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: 9.8 * scale,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isPopular)
            Positioned(
              top: 10 * scale,
              child: Container(
                height: 19 * scale,
                padding: EdgeInsets.symmetric(horizontal: 8 * scale),
                decoration: BoxDecoration(
                  color: AppColors.brandDeepGreen,
                  border: Border.all(color: AppColors.white),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.white,
                      size: 13 * scale,
                    ),
                    SizedBox(width: 3 * scale),
                    Text(
                      locale.subscription_details_most_selected,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 7.8 * scale,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'diamond':
        return Icons.workspace_premium_rounded;
      case 'crown':
        return Icons.workspace_premium_rounded;
      case 'star':
        return Icons.star_border_rounded;
      case 'leaf':
        return Icons.eco_outlined;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }
}

class _PackageIcon extends StatelessWidget {
  const _PackageIcon({required this.icon, required this.package});

  final IconData icon;
  final MonthlyPackageTierEntity package;

  @override
  Widget build(BuildContext context) {
    final isPopular = package.isPopular;
    final background = switch (package.iconName) {
      'crown' => const LinearGradient(
        colors: [Color(0xFF000000), Color(0xFF666666)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      'star' => const LinearGradient(
        colors: [Color(0xFFFF9538), Color(0xFFF6E715)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      _ => const LinearGradient(
        colors: [Color(0xFF51C063), Color(0xFFD0EDCB)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    };

    return Container(
      width: isPopular ? 32 : 29,
      height: isPopular ? 32 : 29,
      decoration: BoxDecoration(
        gradient: background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.white, size: isPopular ? 19 : 17),
    );
  }
}
