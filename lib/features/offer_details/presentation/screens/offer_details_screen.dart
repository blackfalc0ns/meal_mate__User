import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_benefits_section.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_hero_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_primary_button.dart';

class OfferDetailsScreen extends StatelessWidget {
  const OfferDetailsScreen({super.key});

  static const routeName = '/offer-details';
  static const _dataSource = OfferDetailsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final details = _dataSource.getOfferDetails();

    return Scaffold(
      backgroundColor: color.surface,
      extendBody: true,
      appBar: CustomAppBar(
        title: locale.offer_details_title,
        actions: [NotificationButton(onTap: () {})],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          final route = switch (index) {
            0 => AppRoutes.home,
            1 => AppRoutes.calendar,
            3 => AppRoutes.subscriptions,
            4 => AppRoutes.profileSettings,
            _ => AppRoutes.offers,
          };
          Navigator.of(context).pushNamed(route);
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
            icon: Icons.calendar_month_rounded,
            selectedIcon: Icons.calendar_month_rounded,
            label: locale.nav_meals,
          ),
          AppBottomNavBarItem(
            icon: Icons.local_fire_department_outlined,
            selectedIcon: Icons.local_fire_department_rounded,
            animationAsset: Assets.fireAnimation,
            iconSize: Spacing.buttonSmallHeight,
            label: locale.nav_offers,
          ),
          AppBottomNavBarItem(
            icon: Icons.inventory_2_rounded,
            selectedIcon: Icons.inventory_2_rounded,
            iconSize: Spacing.iconMd - Spacing.xs,
            label: locale.nav_subscription,
          ),
          AppBottomNavBarItem(
            icon: Icons.person_rounded,
            selectedIcon: Icons.person_rounded,
            iconSize: Spacing.iconMd,
            label: locale.nav_profile,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.offerDetailsHorizontalPadding,
            end: Spacing.offerDetailsHorizontalPadding,
            top: Spacing.offerDetailsHeaderTopGap,
            bottom: Spacing.offerDetailsBottomNavGap,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OfferDetailsHeroCard(details: details),
              const SizedBox(height: Spacing.base),
              OfferDetailsInfoCard(details: details),
              const SizedBox(height: Spacing.md),
              OfferDetailsBenefitsSection(details: details),
              const SizedBox(height: Spacing.xl),
              OfferDetailsPrimaryButton(
                label: locale.offer_details_plan_section_title,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.subscriptions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
