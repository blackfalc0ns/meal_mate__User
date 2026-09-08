import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_member_selector_item.dart';

class FamilyRestaurantsMemberSelector extends StatelessWidget {
  const FamilyRestaurantsMemberSelector({super.key, required this.members});

  final List<FamilyRestaurantsMemberData> members;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final member in members)
          FamilyRestaurantsMemberSelectorItem(member: member),
      ],
    );
  }
}
