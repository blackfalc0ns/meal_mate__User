import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_date_badge.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_member_selector.dart';

class FamilyRestaurantsHeader extends StatelessWidget {
  const FamilyRestaurantsHeader({
    super.key,
    required this.title,
    required this.dateLabel,
    required this.members,
    required this.onBackPressed,
  });

  final String title;
  final String dateLabel;
  final List<FamilyRestaurantsMemberData> members;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomAppBar(
          title: title,
          onBackPressed: onBackPressed,
          showShadow: false,
          elevation: Spacing.zero,
        ),
        const SizedBox(height: Spacing.sm),
        FamilyRestaurantsMemberSelector(members: members),
        const SizedBox(height: Spacing.md),
        Center(child: FamilyRestaurantsDateBadge(label: dateLabel)),
      ],
    );
  }
}
