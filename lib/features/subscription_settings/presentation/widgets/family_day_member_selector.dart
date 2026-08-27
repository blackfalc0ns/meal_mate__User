import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_selector_item.dart';

class FamilyDayMemberSelector extends StatelessWidget {
  const FamilyDayMemberSelector({
    super.key,
    required this.members,
    required this.selectedIndex,
    required this.onMemberSelected,
  });

  final List<FamilyDayMemberEntity> members;
  final int selectedIndex;
  final ValueChanged<int> onMemberSelected;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      key: const ValueKey('family_day_member_selector'),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var index = 0; index < members.length; index++) ...[
            if (index > 0)
              const SizedBox(width: Spacing.familyDayMemberSelectorGap),
            FamilyDayMemberSelectorItem(
              member: members[index],
              isSelected: index == selectedIndex,
              onSelected: () => onMemberSelected(index),
            ),
          ],
        ],
      ),
    );
  }
}
