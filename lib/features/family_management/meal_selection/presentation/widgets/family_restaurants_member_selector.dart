import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/models/family_restaurants_view_data.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_member_selector_item.dart';

class FamilyRestaurantsMemberSelector extends StatelessWidget {
  const FamilyRestaurantsMemberSelector({
    super.key,
    required this.members,
    required this.onMemberSelected,
  });

  final List<FamilyRestaurantsMemberData> members;
  final ValueChanged<int> onMemberSelected;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      key: const ValueKey('family_restaurants_member_selector'),
      children: [
        for (var index = 0; index < members.length; index++)
          FamilyRestaurantsMemberSelectorItem(
            member: members[index],
            onSelected: () => onMemberSelected(index),
          ),
      ],
    );
  }
}
