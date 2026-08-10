import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';

class FamilyMemberDetailBottomNav extends StatelessWidget {
  const FamilyMemberDetailBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ColoredBox(
      color: color.surface.withValues(alpha: 0),
      child: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          final route = switch (index) {
            0 => AppRoutes.home,
            1 => AppRoutes.calendar,
            2 => AppRoutes.offers,
            3 => AppRoutes.subscriptions,
            _ => AppRoutes.profileSettings,
          };
          context.pushNamed(route);
        },
        items: [
          AppBottomNavBarItem(
            icon: Icons.home_rounded,
            selectedIcon: Icons.home_rounded,
            svgAsset: Assets.logo,
            tintSvg: false,
            label: locale.nav_home,
          ),
          AppBottomNavBarItem(
            icon: Icons.calendar_month,
            selectedIcon: Icons.calendar_month,
            label: locale.nav_meals,
          ),
          AppBottomNavBarItem(
            icon: Icons.local_fire_department_outlined,
            selectedIcon: Icons.local_fire_department,
            animationAsset: Assets.fireAnimation,
            iconSize: 40,
            label: locale.nav_offers,
          ),
          AppBottomNavBarItem(
            icon: Icons.inventory_2,
            selectedIcon: Icons.inventory_2,
            iconSize: 22,
            label: locale.nav_subscription,
          ),
          AppBottomNavBarItem(
            icon: Icons.person_rounded,
            selectedIcon: Icons.person_rounded,
            iconSize: 23,
            label: locale.nav_profile,
          ),
        ],
      ),
    );
  }
}
