import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';

class FamilyRestaurantsMemberSelectorItem extends StatelessWidget {
  const FamilyRestaurantsMemberSelectorItem({super.key, required this.member});

  final FamilyRestaurantsMemberData member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      key: const ValueKey('family_restaurants_member_selector_item'),
      width: Spacing.familyDayMemberSelectorWidth,
      height: Spacing.familyDayMemberSelectorHeight,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Spacing.familyDayMemberSelectorAvatarRadius,
              ),
              child: Image.asset(
                member.imageAsset,
                width: Spacing.familyDayMemberSelectorAvatarWidth,
                height: Spacing.familyDayMemberSelectorAvatarHeight,
                fit: BoxFit.cover,
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
            const SizedBox(height: Spacing.familyDayMemberSelectorCheckBottom),
          ],
        ),
      ),
    );
  }
}
