import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
    final color = context.colorScheme;

    return SizedBox(
      height: Spacing.familyRestaurantsHeaderHeight,
      child: Stack(
        children: [
          PositionedDirectional(
            top: Spacing.familyRestaurantsHeaderTitleTop,
            start: Spacing.zero,
            end: Spacing.zero,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size19,
                color: color.onSurface,
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.familyRestaurantsBackTop,
            end: Spacing.familyRestaurantsBackEnd,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: Spacing.iconMd,
                height: Spacing.iconMd,
              ),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: color.onSurface,
                size: Spacing.iconMd,
              ),
              onPressed: onBackPressed,
            ),
          ),
          PositionedDirectional(
            top: Spacing.familyRestaurantsMemberSelectorTop,
            start: Spacing.zero,
            end: Spacing.zero,
            child: FamilyRestaurantsMemberSelector(members: members),
          ),
          PositionedDirectional(
            top: Spacing.familyRestaurantsDateWithMembersTop,
            start: Spacing.zero,
            end: Spacing.zero,
            child: Center(child: FamilyRestaurantsDateBadge(label: dateLabel)),
          ),
        ],
      ),
    );
  }
}
