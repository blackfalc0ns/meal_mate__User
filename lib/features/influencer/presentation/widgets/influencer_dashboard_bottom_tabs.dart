import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';

enum InfluencerDashboardTabItem { profile, stats, wallet, links, home }

class InfluencerDashboardBottomTabs extends StatelessWidget {
  const InfluencerDashboardBottomTabs({
    super.key,
    this.selectedTab = InfluencerDashboardTabItem.home,
    required this.onTabSelected,
  });

  final InfluencerDashboardTabItem selectedTab;
  final ValueChanged<InfluencerDashboardTabItem> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final tabs = [
      _InfluencerDashboardTab(
        itemKey: const ValueKey('influencer-tab-stats'),
        label: locale.influencer_tab_stats,
        iconAsset: AssetsFake.influencerTabStats,
        icon: Icons.bar_chart_rounded,
        tab: InfluencerDashboardTabItem.stats,
      ),
      _InfluencerDashboardTab(
        itemKey: const ValueKey('influencer-tab-wallet'),
        label: locale.influencer_tab_wallet,
        iconAsset: AssetsFake.influencerTabWallet,
        icon: Icons.account_balance_wallet_rounded,
        tab: InfluencerDashboardTabItem.wallet,
      ),
      _InfluencerDashboardTab(
        itemKey: const ValueKey('influencer-tab-links'),
        label: locale.influencer_tab_links,
        iconAsset: AssetsFake.influencerTabLinks,
        icon: Icons.link_rounded,
        tab: InfluencerDashboardTabItem.links,
      ),
      _InfluencerDashboardTab(
        itemKey: const ValueKey('influencer-tab-home'),
        label: locale.influencer_tab_home,
        iconAsset: AssetsFake.influencerTabHome,
        icon: Icons.home_rounded,
        tab: InfluencerDashboardTabItem.home,
      ),
    ];

    return AppBottomNavBar(
      currentIndex: tabs.indexWhere((tab) => tab.tab == selectedTab),
      activeColor: color.onPrimary,
      inactiveColor: color.onSurface,
      activeBackground: color.primary,
      layoutTextDirection: TextDirection.ltr,
      onTap: (index) {
        final tab = tabs[index];
        if (tab.tab == selectedTab) return;
        onTabSelected(tab.tab);
      },
      items: [
        for (final tab in tabs)
          AppBottomNavBarItem(
            itemKey: tab.itemKey,
            label: tab.label,
            icon: tab.icon,
            selectedIcon: tab.icon,
            svgAsset: tab.iconAsset,
          ),
      ],
    );
  }
}

class _InfluencerDashboardTab {
  const _InfluencerDashboardTab({
    required this.itemKey,
    required this.label,
    required this.iconAsset,
    required this.icon,
    required this.tab,
  });

  final Key itemKey;
  final String label;
  final String iconAsset;
  final IconData icon;
  final InfluencerDashboardTabItem tab;
}
