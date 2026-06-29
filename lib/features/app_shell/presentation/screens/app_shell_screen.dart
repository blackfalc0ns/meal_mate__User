import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/features/home/data/home_fake_data_source.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_cubit.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_state.dart';
import 'package:meal_meat_user/features/home/presentation/screens/home_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(const HomeFakeDataSource())..loadHome(),
      child: const _AppShellView(),
    );
  }
}

class _AppShellView extends StatelessWidget {
  const _AppShellView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    final navItems = [
      AppBottomNavBarItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: l10n.nav_home,
        sfSymbol: 'house.fill',
      ),
      AppBottomNavBarItem(
        icon: Icons.restaurant_menu_outlined,
        selectedIcon: Icons.restaurant_menu,
        label: l10n.nav_meals,
        sfSymbol: 'fork.knife',
      ),
      AppBottomNavBarItem(
        icon: Icons.local_fire_department_outlined,
        selectedIcon: Icons.local_fire_department,
        label: l10n.nav_offers,
        sfSymbol: 'flame.fill',
      ),
      AppBottomNavBarItem(
        icon: Icons.card_membership_outlined,
        selectedIcon: Icons.card_membership,
        label: l10n.nav_subscription,
        sfSymbol: 'star.fill',
      ),
      AppBottomNavBarItem(
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        label: l10n.nav_profile,
        sfSymbol: 'person.fill',
      ),
    ];

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, cur) => prev.selectedTabIndex != cur.selectedTabIndex,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          // extendBody lets the page content slide under the glass capsule.
          extendBody: false,
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: state.selectedTabIndex,
            onTap: (index) => context.read<HomeCubit>().selectTab(index),
            items: navItems,
          ),
          body: IndexedStack(
            index: state.selectedTabIndex,
            children: [
              const HomeScreen(),
              _ShellPlaceholderView(
                title: l10n.nav_meals,
                subtitle: l10n.coming_soon_subtitle,
              ),
              const OffersScreen(),
              _ShellPlaceholderView(
                title: l10n.nav_subscription,
                subtitle: l10n.coming_soon_subtitle,
              ),
              _ShellPlaceholderView(
                title: l10n.nav_profile,
                subtitle: l10n.coming_soon_subtitle,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShellPlaceholderView extends StatelessWidget {
  const _ShellPlaceholderView({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction_rounded,
              size: 72,
              color: AppColors.primary,
            ),
            const SizedBox(height: Spacing.base),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
