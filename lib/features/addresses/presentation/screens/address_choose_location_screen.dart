import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_figma_frame.dart';

class AddressChooseLocationScreen extends StatelessWidget {
  const AddressChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surfaceContainerHighest,
      drawerScrimColor: color.scrim,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Semantics(
              label: locale.addresses_choose_location_title,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final scale =
                      constraints.maxWidth /
                      Spacing.addressesChooseLocationDesignWidth;
                  final contentHeight =
                      Spacing.addressesChooseLocationDesignHeight * scale;

                  return SingleChildScrollView(
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: contentHeight,
                      child: FittedBox(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                        child: const SizedBox(
                          width: Spacing.addressesChooseLocationDesignWidth,
                          height: Spacing.addressesChooseLocationDesignHeight,
                          child: AddressesFigmaFrame(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: Spacing.zero,
            right: Spacing.zero,
            bottom: Spacing.zero,
            child: AppBottomNavBar(
              currentIndex: 0,
              onTap: (index) => _handleBottomNavTap(context, index),
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
                  iconSize: Spacing.xxl + Spacing.sm,
                  label: locale.nav_offers,
                ),
                AppBottomNavBarItem(
                  icon: Icons.inventory_2,
                  selectedIcon: Icons.inventory_2,
                  iconSize: Spacing.xl - Spacing.xs,
                  label: locale.nav_subscription,
                ),
                AppBottomNavBarItem(
                  icon: Icons.person_rounded,
                  selectedIcon: Icons.person_rounded,
                  iconSize: Spacing.xl - Spacing.xs,
                  label: locale.nav_profile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    final routes = [
      AppRoutes.home,
      AppRoutes.calendar,
      AppRoutes.offers,
      AppRoutes.subscriptions,
      AppRoutes.profileSettings,
    ];
    Navigator.of(context).pushNamedAndRemoveUntil(routes[index], (_) => false);
  }
}
