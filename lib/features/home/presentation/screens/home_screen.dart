import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/features/home/data/home_fake_data_source.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_cubit.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_state.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_category_strip.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_header_section.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_meal_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_promo_banner.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(const HomeFakeDataSource())..loadHome(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              previous.selectedTabIndex != current.selectedTabIndex,
          builder: (context, state) {
            return AppBottomNavBar(
              currentIndex: state.selectedTabIndex,
              onTap: (index) => context.read<HomeCubit>().selectTab(index),
              items: const [
                AppBottomNavBarItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'الرئيسية',
                ),
                AppBottomNavBarItem(
                  icon: Icons.restaurant_menu_outlined,
                  selectedIcon: Icons.restaurant_menu,
                  label: 'الوجبات',
                ),
                AppBottomNavBarItem(
                  icon: Icons.local_fire_department_outlined,
                  selectedIcon: Icons.local_fire_department,
                  label: 'العروض',
                  isAnimated: true,
                ),
                AppBottomNavBarItem(
                  icon: Icons.card_membership_outlined,
                  selectedIcon: Icons.card_membership,
                  label: 'الاشتراك',
                ),
                AppBottomNavBarItem(
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: 'البروفايل',
                ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading ||
                state.dashboard == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final dashboard = state.dashboard!;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeaderSection(
                    dashboard: dashboard,
                    onNotificationTap: () {},
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Spacing.base),
                    child: HomeSearchBar(onTap: () {}),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: Spacing.base)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Spacing.base),
                    child: HomePromoBanner(
                      title: dashboard.bannerTitle,
                      subtitle: dashboard.bannerSubtitle,
                      buttonLabel: dashboard.bannerButtonLabel,
                      imageAsset: dashboard.bannerImageAsset,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
                SliverToBoxAdapter(
                  child: HomeCategoryStrip(
                    categories: dashboard.categories,
                    selectedIndex: state.selectedCategoryIndex,
                    onCategorySelected: context.read<HomeCubit>().selectCategory,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: Spacing.sm)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final meal = dashboard.meals[index];
                      return HomeMealCard(meal: meal);
                    },
                    childCount: dashboard.meals.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
              ],
            );
          },
        ),
      ),
    );
  }
}
