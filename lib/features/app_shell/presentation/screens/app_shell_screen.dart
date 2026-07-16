import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/features/app_shell/presentation/widgets/app_zoom_drawer_shell.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:meal_meat_user/features/home/data/home_fake_data_source.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_cubit.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_state.dart';
import 'package:meal_meat_user/features/home/presentation/screens/home_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/profile_screen.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/screens/subscriptions_screen.dart';

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
        icon: Icons.home_rounded,
        selectedIcon: Icons.home_rounded,
        svgAsset: Assets.logo,
        tintSvg: false,
        label: l10n.nav_home,
        sfSymbol: 'house.fill',
      ),
      AppBottomNavBarItem(
        icon: Icons.calendar_month,
        selectedIcon: Icons.calendar_month,
        label: l10n.nav_meals,
        sfSymbol: 'fork.knife',
      ),
      AppBottomNavBarItem(
        icon: Icons.local_fire_department_outlined,
        selectedIcon: Icons.local_fire_department,
        animationAsset: Assets.fireAnimation,
        iconSize: 40,
        label: l10n.nav_offers,
        sfSymbol: 'flame.fill',
      ),
      AppBottomNavBarItem(
        icon: Icons.inventory_2,
        selectedIcon: Icons.inventory_2,
        iconSize: 22,
        label: l10n.nav_subscription,
        sfSymbol: 'star.fill',
      ),
      AppBottomNavBarItem(
        icon: Icons.person_rounded,
        selectedIcon: Icons.person_rounded,
        iconSize: 23,
        label: l10n.nav_profile,
        sfSymbol: 'person.fill',
      ),
    ];

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, cur) => prev.selectedTabIndex != cur.selectedTabIndex,
      builder: (context, state) {
        final dashboard = state.dashboard;

        return AppZoomDrawerShell(
          userName: dashboard?.userName ?? l10n.drawer_guest_name,
          greeting: dashboard?.greeting ?? l10n.drawer_welcome,
          avatarAsset: Assets.homeFigmaAvatar,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // Keep the area around the floating glass pill transparent and let
            // the current page remain visible through it, as in the Figma design.
            extendBody: true,
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: state.selectedTabIndex,
              onTap: (index) => context.read<HomeCubit>().selectTab(index),
              items: navItems,
            ),
            body: _AnimatedShellBody(
              selectedIndex: state.selectedTabIndex,
              children: [
                const HomeScreen(),
                const CalendarScreen(showBottomSpace: true),
                const OffersScreen(),
                const SubscriptionsScreen(showBottomSpace: true),
                const ProfileScreen(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedShellBody extends StatefulWidget {
  const _AnimatedShellBody({
    required this.selectedIndex,
    required this.children,
  });

  final int selectedIndex;
  final List<Widget> children;

  @override
  State<_AnimatedShellBody> createState() => _AnimatedShellBodyState();
}

class _AnimatedShellBodyState extends State<_AnimatedShellBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  int _previousIndex = 0;
  double _slideDirection = 1;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.selectedIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..value = 1;
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedShellBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex) return;

    _slideDirection = widget.selectedIndex > _previousIndex ? 1 : -1;
    _previousIndex = widget.selectedIndex;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: IndexedStack(
        index: widget.selectedIndex,
        children: widget.children,
      ),
      builder: (context, child) {
        final value = _animation.value;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * 18 * _slideDirection, 0),
            child: child,
          ),
        );
      },
    );
  }
}
