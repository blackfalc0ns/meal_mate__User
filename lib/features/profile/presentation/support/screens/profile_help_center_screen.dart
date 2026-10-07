import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/profile/data/fake/profile_support_fake_data.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_content_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/support/widgets/profile_faq_item.dart';
import 'package:meal_meat_user/features/profile/presentation/support/widgets/profile_support_intro_card.dart';

class ProfileHelpCenterScreen extends StatelessWidget {
  const ProfileHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.profile_settings_help_center,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.profilePrivacyScreenHorizontalPadding,
          ).copyWith(top: Spacing.profilePrivacyContentTopPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileSupportIntroCard(
                icon: Icons.menu_book_rounded,
                title: locale.profile_help_center_intro_title,
                description: locale.profile_help_center_intro_desc,
              ),
              const SizedBox(height: Spacing.md),
              const _ProfileFaqSection(),
              const SizedBox(height: Spacing.lg),
              const _ProfileHelpCenterBottomLinks(),
              const SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileFaqSection extends StatefulWidget {
  const _ProfileFaqSection();

  @override
  State<_ProfileFaqSection> createState() => _ProfileFaqSectionState();
}

class _ProfileFaqSectionState extends State<_ProfileFaqSection> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _expandedIds = <String>{};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final trimmed = _searchController.text.trim();
    if (trimmed != _searchQuery) {
      setState(() {
        _searchQuery = trimmed;
      });
    }
  }

  void _toggleExpanded(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    const allItems = ProfileSupportFakeData.faqItems;
    final query = _searchQuery.toLowerCase();

    final filteredItems = allItems.where((item) {
      if (query.isEmpty) return true;
      final q = item.question(locale).toLowerCase();
      final a = item.answer(locale).toLowerCase();
      return q.contains(query) || a.contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _searchController,
          hint: locale.profile_help_center_search_hint,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: color.onSurfaceVariant,
            size: Spacing.iconMd,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: color.onSurfaceVariant,
                    size: Spacing.iconSm,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
        ),
        const SizedBox(height: Spacing.md),
        if (filteredItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(Spacing.xl),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(
                color: color.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: Spacing.iconLg,
                  color: color.onSurfaceVariant,
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  locale.profile_help_center_search_empty_title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  locale.profile_help_center_search_empty_desc,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                AppButton.outlined(
                  text: locale.profile_help_center_clear_search,
                  onPressed: _clearSearch,
                  height: Spacing.buttonSmallHeight,
                  color: color.primary,
                  textColor: color.primary,
                  fontSize: FontSize.size11,
                ),
              ],
            ),
          )
        else
          ...filteredItems.map(
            (ProfileSupportFaqItemEntity item) => ProfileFaqItem(
              key: ValueKey(item.id),
              question: item.question(locale),
              answer: item.answer(locale),
              isExpanded: _expandedIds.contains(item.id),
              onTap: () => _toggleExpanded(item.id),
            ),
          ),
      ],
    );
  }
}

class _ProfileHelpCenterBottomLinks extends StatelessWidget {
  const _ProfileHelpCenterBottomLinks();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.profile_help_center_need_more_help,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.profile_settings_contact_us_subtitle,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton.filled(
                  text: locale.profile_help_center_contact_us_action,
                  onPressed: () => unawaited(
                    Navigator.of(context).pushNamed(AppRoutes.profileContactUs),
                  ),
                  height: Spacing.buttonSmallHeight,
                  borderRadius: Spacing.radiusSm,
                  color: color.primary,
                  textColor: color.onPrimary,
                  fontSize: FontSize.size11,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: AppButton.outlined(
                  text: locale.profile_help_center_complaint_action,
                  onPressed: () => unawaited(
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.profileComplaints),
                  ),
                  height: Spacing.buttonSmallHeight,
                  borderRadius: Spacing.radiusSm,
                  color: color.outlineVariant,
                  textColor: color.onSurface,
                  fontSize: FontSize.size11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
