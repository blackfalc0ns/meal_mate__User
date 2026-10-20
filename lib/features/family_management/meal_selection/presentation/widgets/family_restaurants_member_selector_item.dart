import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/models/family_restaurants_view_data.dart';

class FamilyRestaurantsMemberSelectorItem extends StatelessWidget {
  const FamilyRestaurantsMemberSelectorItem({
    super.key,
    required this.member,
    required this.onSelected,
  });

  final FamilyRestaurantsMemberData member;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      key: const ValueKey('family_restaurants_member_selector_item'),
      width: Spacing.familyDayMemberSelectorWidth,
      height: Spacing.familyDayMemberSelectorHeight,
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(
          Spacing.familyDayMemberSelectorSelectedRadius,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(
              color: member.isSelected ? color.primary : color.outlineVariant,
              width: member.isSelected
                  ? Spacing.familySelectedBorderWidth
                  : Spacing.border,
            ),
            borderRadius: BorderRadius.circular(
              Spacing.familyDayMemberSelectorSelectedRadius,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: Spacing.familyDayMemberSelectorAvatarTop),
              SizedBox(
                width: Spacing.familyDayMemberSelectorAvatarWidth,
                height: Spacing.familyDayMemberSelectorAvatarHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: color.onSurfaceVariant,
                    size: Spacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.familyDayMemberSelectorNameTopGap),
              Text(
                member.name,
                locale: Locale(locale.localeName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
              const Spacer(),
              if (member.isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  size: Spacing.familyDayMemberSelectorCheckSize,
                  color: color.primary,
                )
              else
                Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.outlineVariant,
                  ),
                ),
              const SizedBox(
                height: Spacing.familyDayMemberSelectorCheckBottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
