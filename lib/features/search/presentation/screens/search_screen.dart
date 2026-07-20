import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/search/data/search_fake_data_source.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_active_results_section.dart';
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
                    SizedBox.square(
                      dimension: Spacing.xxxl,
                      child: AppButton.filled(
                        text: '',
                        onPressed: () {},
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
                          selectedFilter: _selectedFilter,
                          results: _dataSource.quickResults,
                          onSuggestionTap: _setQuery,
                          onFilterSelected: (index) =>
                              setState(() => _selectedFilter = index),
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
}
