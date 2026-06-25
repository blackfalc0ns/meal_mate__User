import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
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
    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading || state.dashboard == null) {
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
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.base,
                    vertical: Spacing.xl,
                  ),
                  child: HomePromoBanner(
                    title: dashboard.bannerTitle,
                    subtitle: dashboard.bannerSubtitle,
                    buttonLabel: dashboard.bannerButtonLabel,
                    imageAsset: dashboard.bannerImageAsset,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: HomeCategoryStrip(
                  categories: dashboard.categories,
                  selectedIndex: state.selectedCategoryIndex,
                  onCategorySelected: context.read<HomeCubit>().selectCategory,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: Spacing.sm)),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final meal = dashboard.meals[index];
                  return HomeMealCard(meal: meal);
                }, childCount: dashboard.meals.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 92)),
            ],
          );
        },
      ),
    );
  }
}
