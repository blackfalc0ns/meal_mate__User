import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_assurance_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_filter_strip.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_grid.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_header.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_search_field.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_section_title.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_summary_card.dart';

class FamilyRestaurantsScreen extends StatelessWidget {
  const FamilyRestaurantsScreen({super.key});

  static const _dataSource = FamilyRestaurantsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final data = _dataSource.getContent(locale);

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.familyRestaurantsHorizontalPadding,
            end: Spacing.familyRestaurantsHorizontalPadding,
            bottom: Spacing.familyRestaurantsBottomSpace,
          ),
          child: Column(
            children: [
              FamilyRestaurantsHeader(
                title: locale.family_restaurants_title(data.memberName),
                dateLabel: data.dateLabel,
                members: data.members,
                onBackPressed: () => Navigator.maybePop(context),
              ),
              FamilyRestaurantsSummaryCard(
                memberName: data.memberName,
                summary: data.summary,
              ),
              const SizedBox(height: Spacing.familyRestaurantsSearchTopGap),
              FamilyRestaurantsSearchField(hint: data.searchHint),
              const SizedBox(height: Spacing.familyRestaurantsFilterTopGap),
              FamilyRestaurantsFilterStrip(filters: data.filters),
              const SizedBox(height: Spacing.familyRestaurantsTitleTopGap),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FamilyRestaurantsSectionTitle(
                  title: locale.family_restaurants_suitable_title(
                    data.memberName,
                  ),
                  subtitle: data.subtitle,
                ),
              ),
              const SizedBox(height: Spacing.familyRestaurantsGridTopGap),
              FamilyRestaurantsGrid(restaurants: data.restaurants),
              const SizedBox(height: Spacing.familyRestaurantsAssuranceTopGap),
              FamilyRestaurantsAssuranceCard(
                title: data.assuranceTitle,
                subtitle: data.assuranceSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
