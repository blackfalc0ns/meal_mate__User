import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/models/family_restaurants_view_data.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_date_badge.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_member_selector.dart';

class FamilyRestaurantsHeader extends StatelessWidget {
  const FamilyRestaurantsHeader({
    super.key,
    required this.title,
    required this.dateLabel,
    required this.members,
    required this.onMemberSelected,
    required this.onBackPressed,
  });

  final String title;
  final String dateLabel;
  final List<FamilyRestaurantsMemberData> members;
  final ValueChanged<int> onMemberSelected;
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
        FamilyRestaurantsMemberSelector(
          members: members,
          onMemberSelected: onMemberSelected,
        ),
        const SizedBox(height: Spacing.md),
        Center(child: FamilyRestaurantsDateBadge(label: dateLabel)),
      ],
    );
  }
}
