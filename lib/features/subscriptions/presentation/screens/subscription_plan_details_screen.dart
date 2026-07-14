import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_details_header.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_package_choice_card.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_selected_program_card.dart';

class SubscriptionPlanDetailsScreen extends StatefulWidget {
  const SubscriptionPlanDetailsScreen({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  State<SubscriptionPlanDetailsScreen> createState() =>
      _SubscriptionPlanDetailsScreenState();
}

class _SubscriptionPlanDetailsScreenState
    extends State<SubscriptionPlanDetailsScreen> {
  late int _selectedPackageIndex;
  int _selectedNavIndex = 3;

  @override
  void initState() {
    super.initState();
    _selectedPackageIndex = widget.initialPage.clamp(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final packages = [
      _PackageChoiceData(
        title: locale.subscription_four_meals_package,
        subtitle: locale.subscription_four_meals_details,
        isPopular: true,
      ),
      _PackageChoiceData(
        title: locale.subscription_three_meals_package,
        subtitle: locale.subscription_three_meals_details,
      ),
      _PackageChoiceData(
        title: locale.subscription_two_meals_package,
        subtitle: locale.subscription_two_meals_details,
      ),
      _PackageChoiceData(
        title: locale.subscription_week_plan_title,
        subtitle: locale.subscription_two_meals_details,
        price: '930',
        currency: locale.currency,
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: color.surface,
        extendBody: true,
        bottomNavigationBar: AppBottomNavBar(
          items: _navItems(locale),
          currentIndex: _selectedNavIndex,
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Spacing.xxxl * 3.45,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.primaryContainer.withValues(alpha: 0.55),
                      color.primaryContainer.withValues(alpha: 0.18),
                      color.surface.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SubscriptionDetailsHeader(onBack: _pop),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: Spacing.lg),
                    sliver: SliverToBoxAdapter(
                      child: SubscriptionSelectedProgramCard(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Spacing.xxl,
                        left: Spacing.lg,
                        right: Spacing.lg,
                        bottom: Spacing.md,
                      ),
                      child: Text(
                        locale.subscription_choose_plan_title,
                        textAlign: TextAlign.right,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size16,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: Spacing.lg,
                      right: Spacing.lg,
                      bottom: Spacing.xxxl * 2.85,
                    ),
                    sliver: SliverList.separated(
                      itemCount: packages.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: Spacing.base),
                      itemBuilder: (context, index) {
                        final package = packages[index];

                        return SubscriptionPackageChoiceCard(
                          title: package.title,
                          subtitle: package.subtitle,
                          isPopular: package.isPopular,
                          isSelected: index == _selectedPackageIndex,
                          price: package.price,
                          currency: package.currency,
                          onTap: () =>
                              setState(() => _selectedPackageIndex = index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AppBottomNavBarItem> _navItems(AppLocalizations locale) {
    return [
      AppBottomNavBarItem(
        icon: Icons.home_rounded,
        selectedIcon: Icons.home_rounded,
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
        iconSize: Spacing.iconXl,
        label: locale.nav_offers,
      ),
      AppBottomNavBarItem(
        icon: Icons.inventory_2,
        selectedIcon: Icons.inventory_2,
        iconSize: Spacing.iconMd - Spacing.xs,
        label: locale.nav_subscription,
      ),
      AppBottomNavBarItem(
        icon: Icons.person_rounded,
        selectedIcon: Icons.person_rounded,
        iconSize: Spacing.iconMd,
        label: locale.nav_profile,
      ),
    ];
  }

  void _pop() {
    Navigator.maybePop(context);
  }
}

class _PackageChoiceData {
  const _PackageChoiceData({
    required this.title,
    required this.subtitle,
    this.isPopular = false,
    this.price,
    this.currency,
  });

  final String title;
  final String subtitle;
  final bool isPopular;
  final String? price;
  final String? currency;
}
