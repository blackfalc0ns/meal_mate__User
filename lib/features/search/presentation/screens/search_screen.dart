import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/search/data/search_fake_data_source.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_filter_strip.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_input.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_quick_category_strip.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_result_card.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_section_title.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_suggestions_panel.dart';

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
                    IconButton.filled(
                      onPressed: () {},
                      icon: Icon(Icons.tune_rounded, color: color.onPrimary),
                      style: IconButton.styleFrom(
                        backgroundColor: color.primary,
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
                      ? ListView(
                          key: const ValueKey('searching'),
                          children: [
                            SearchSuggestionsPanel(
                              suggestions: content.suggestions,
                              onSuggestionTap: _setQuery,
                            ),
                            const SizedBox(height: Spacing.lg),
                            SearchFilterStrip(
                              selectedIndex: _selectedFilter,
                              onSelected: (index) =>
                                  setState(() => _selectedFilter = index),
                            ),
                            const SizedBox(height: Spacing.sm),
                            SearchSectionTitle(
                              title: locale.search_quick_results,
                              icon: Icons.star_rounded,
                            ),
                            const SizedBox(height: Spacing.sm),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _dataSource.quickResults.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: Spacing.md,
                                      mainAxisSpacing: Spacing.md,
                                      childAspectRatio: .78,
                                    ),
                                itemBuilder: (context, index) =>
                                    SearchResultCard(
                                      result: _dataSource.quickResults[index],
                                    ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xxxl),
                          ],
                        )
                      : ListView(
                          key: const ValueKey('initial'),
                          children: [
                            SearchSectionTitle(
                              title: locale.search_recent,
                              icon: Icons.history_rounded,
                            ),
                            const SizedBox(height: Spacing.sm),
                            SizedBox(
                              height: Spacing.xxxl - Spacing.xss,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: Spacing.sm),
                                  itemBuilder: (context, index) {
                                    final labels = [
                                      locale.search_recent_grilled_chicken,
                                      locale.search_recent_healthy_restaurants,
                                      locale.search_recent_high_protein,
                                    ];
                                    final label = labels[index];
                                    return ActionChip(
                                      onPressed: () => _setQuery(label),
                                      avatar: Icon(
                                        Icons.search_rounded,
                                        color: color.onPrimary,
                                        size: Spacing.iconSm,
                                      ),
                                      backgroundColor: color.primary,
                                      side: BorderSide.none,
                                      label: Text(
                                        label,
                                        style: getMediumStyle(
                                          fontFamily:
                                              FontConstant.ibmPlexSansArabic,
                                          fontSize: FontSize.size10,
                                          color: color.onPrimary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            SearchSectionTitle(
                              title: locale.search_popular,
                              icon: Icons.bar_chart_rounded,
                            ),
                            const SizedBox(height: Spacing.sm),
                            SearchQuickCategoryStrip(
                              categories: _dataSource.quickCategories,
                              labels: content.categoryLabels,
                              subtitles: content.categorySubtitles,
                              onCategoryTap: (_) => _setQuery(
                                locale.search_recent_grilled_chicken,
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            SearchSectionTitle(
                              title: locale.search_categories,
                              icon: Icons.grid_view_rounded,
                            ),
                            const SizedBox(height: Spacing.sm),
                            SizedBox(
                              height: Spacing.searchQuickCategoryCardHeight,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: content.quickCategoryItems.length,
                                  separatorBuilder: (_, _) => const SizedBox(
                                    width: Spacing.searchQuickCategoryGap,
                                  ),
                                  itemBuilder: (context, index) {
                                    final item =
                                        content.quickCategoryItems[index];
                                    return Container(
                                      width:
                                          Spacing.searchQuickCategoryCardWidth,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.xs,
                                        vertical: Spacing.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.surface,
                                        border: Border.all(
                                          color: color.outlineVariant,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          Spacing.radiusMd,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            item.icon,
                                            color: color.primary,
                                            size: Spacing.iconLg,
                                          ),
                                          const SizedBox(height: Spacing.xs),
                                          Text(
                                            item.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: getBoldStyle(
                                              fontFamily: FontConstant
                                                  .ibmPlexSansArabic,
                                              fontSize: FontSize.size10,
                                              color: color.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            SearchSectionTitle(
                              title: locale.search_recommended,
                              icon: Icons.star_rounded,
                            ),
                            const SizedBox(height: Spacing.sm),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _dataSource.quickResults.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: Spacing.md,
                                      mainAxisSpacing: Spacing.md,
                                      childAspectRatio: .78,
                                    ),
                                itemBuilder: (context, index) =>
                                    SearchResultCard(
                                      result: _dataSource.quickResults[index],
                                    ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xxxl),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
