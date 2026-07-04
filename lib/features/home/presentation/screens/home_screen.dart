import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/app_shell/presentation/widgets/app_zoom_drawer_shell.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_cubit.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_state.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_category_strip.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_header_section.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_meal_card.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_promo_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading || state.dashboard == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final dashboard = state.dashboard!;
        return Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                Assets.homeFigmaBackgroundDoodle,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.04),
                  BlendMode.srcIn,
                ),
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeaderSection(
                    dashboard: dashboard,
                    onMenuTap: () => DrawerControllerScope.openDrawer(context),
                    onNotificationTap: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: HomePromoBanner(
                      title: dashboard.bannerTitle,
                      subtitle: dashboard.bannerSubtitle,
                      buttonLabel: dashboard.bannerButtonLabel,
                      imageAsset: dashboard.bannerImageAsset,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 13)),
                SliverToBoxAdapter(
                  child: HomeCategoryStrip(
                    categories: dashboard.categories,
                    selectedIndex: state.selectedCategoryIndex,
                    onCategorySelected: context
                        .read<HomeCubit>()
                        .selectCategory,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 13)),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final meal = dashboard.meals[index];
                    return HomeMealCard(meal: meal);
                  }, childCount: dashboard.meals.length),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 92)),
              ],
            ),
          ],
        );
      },
    );
  }
}
