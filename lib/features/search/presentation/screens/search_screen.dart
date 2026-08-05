import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/search/data/search_fake_data_source.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_active_results_section.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_filter_bottom_sheet.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_initial_sections.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_input.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _dataSource = const SearchFakeDataSource();
  var _selectedFilter = 0;
  var _filterCriteria = const SearchFilterCriteria.initial();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _setQuery(String value) {
    _controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isSearching = _controller.text.isNotEmpty;
    final content = _dataSource.getContent(locale);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: _onNavigationTap,
        items: [
          AppBottomNavBarItem(
            icon: Icons.home_rounded,
            selectedIcon: Icons.home_rounded,
            svgAsset: Assets.logo,
            tintSvg: false,
            label: locale.nav_home,
            sfSymbol: 'house.fill',
          ),
          AppBottomNavBarItem(
            icon: Icons.calendar_month,
            selectedIcon: Icons.calendar_month,
            label: locale.nav_meals,
            sfSymbol: 'fork.knife',
          ),
          AppBottomNavBarItem(
            icon: Icons.local_fire_department_outlined,
            selectedIcon: Icons.local_fire_department,
            animationAsset: Assets.fireAnimation,
            iconSize: Spacing.xxl + Spacing.sm,
            label: locale.nav_offers,
            sfSymbol: 'flame.fill',
          ),
          AppBottomNavBarItem(
            icon: Icons.inventory_2,
            selectedIcon: Icons.inventory_2,
            iconSize: Spacing.xl - Spacing.xs / 2,
            label: locale.nav_subscription,
            sfSymbol: 'star.fill',
          ),
          AppBottomNavBarItem(
            icon: Icons.person_rounded,
            selectedIcon: Icons.person_rounded,
            iconSize: Spacing.xl - Spacing.xs,
            label: locale.nav_profile,
            sfSymbol: 'person.fill',
          ),
        ],
      ),
      appBar: CustomAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: SizedBox(
              width: Spacing.xxxl + Spacing.xxxl + Spacing.base,
              height: Spacing.xl + Spacing.xs,
              child: SvgPicture.asset(Assets.mealMateLogo, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.searchScreenHorizontalPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: Spacing.sm),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: SearchInput(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: (_) => setState(() {}),
                      onCancel: () {
                        _controller.clear();
                        _focusNode.unfocus();
                        setState(() {});
                      },
                      showCancel: isSearching,
                    ),
                  ),
                  if (!isSearching) ...[
                    const SizedBox(width: Spacing.sm),
                    SizedBox.square(
                      dimension: Spacing.xxxl,
                      child: AppButton.filled(
                        text: '',
                        onPressed: _openFilterSheet,
                        iconWidget: SizedBox.square(
                          dimension: Spacing.xxxl,
                          child: SvgPicture.asset(
                            AssetsFake.searchFilterIcon,
                            fit: BoxFit.contain,
                          ),
                        ),
                        isExpanded: false,
                        height: Spacing.xxxl,
                        borderRadius: Spacing.radiusPill,
                        color: color.surface,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: Spacing.lg),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isSearching
                      ? SearchActiveResultsSection(
                          suggestions: content.suggestions,
                          query: _controller.text,
                          selectedFilter: _selectedFilter,
                          results: _filteredResults,
                          onSuggestionTap: _setQuery,
                          onFilterSelected: (index) =>
                              setState(() => _selectedFilter = index),
                          onExploreTap: _clearSearch,
                          onClearTap: _clearSearch,
                        )
                      : SearchInitialSections(
                          content: content,
                          categories: _dataSource.quickCategories,
                          results: _dataSource.quickResults,
                          onQuery: _setQuery,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<SearchResult> get _filteredResults {
    final normalizedQuery = _controller.text.trim().toLowerCase();
    if (normalizedQuery ==
        context.localization.search_empty_query.toLowerCase()) {
      return const [];
    }

    return _dataSource.quickResults
        .where(
          (result) => _filterCriteria.showMeals
              ? result == SearchResult.meal
              : result == SearchResult.restaurant,
        )
        .toList();
  }

  void _clearSearch() {
    _controller.clear();
    _focusNode.unfocus();
    setState(() {});
  }

  void _onNavigationTap(int index) {
    final routes = [
      AppRoutes.home,
      AppRoutes.calendar,
      AppRoutes.offers,
      AppRoutes.subscriptions,
      AppRoutes.profileSettings,
    ];
    context.pushReplacementNamed(routes[index]);
  }

  Future<void> _openFilterSheet() async {
    final criteria = await showModalBottomSheet<SearchFilterCriteria>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (_) => SearchFilterBottomSheet(initialCriteria: _filterCriteria),
    );
    if (!mounted || criteria == null) {
      return;
    }
    setState(() => _filterCriteria = criteria);
  }
}
