import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
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

    return SingleChildScrollView(
      key: const ValueKey('family_restaurants_member_selector'),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var index = 0; index < members.length; index++) ...[
            if (index > 0)
              const SizedBox(width: Spacing.familyDayMemberSelectorGap),
            FamilyRestaurantsMemberSelectorItem(member: members[index]),
          ],
        ],
      ),
    );
  }
}
