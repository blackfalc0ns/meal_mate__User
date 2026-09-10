import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';

class FamilyDayMemberSelectorItem extends StatelessWidget {
  const FamilyDayMemberSelectorItem({
    super.key,
    required this.member,
    required this.isSelected,
    required this.onSelected,
  });

  final FamilyDayMemberEntity member;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return InkWell(
      key: const ValueKey('family_day_member_selector_item'),
      onTap: onSelected,
      borderRadius: BorderRadius.circular(
        isSelected
            ? Spacing.familyDayMemberSelectorSelectedRadius
            : Spacing.familyDayMemberSelectorRadius,
      ),
      child: SizedBox(
        width: Spacing.familyDayMemberSelectorWidth,
        height: Spacing.familyDayMemberSelectorHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? color.primaryContainer : color.surface,
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
              width: isSelected
                  ? Spacing.familySelectedBorderWidth
                  : Spacing.familyDayMealCardBorderWidth,
            ),
            borderRadius: BorderRadius.circular(
              isSelected
                  ? Spacing.familyDayMemberSelectorSelectedRadius
                  : Spacing.familyDayMemberSelectorRadius,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: Spacing.familyDayMemberSelectorAvatarTop),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  Spacing.familyDayMemberSelectorAvatarRadius,
                ),
                child: member.imageUrl?.isNotEmpty == true
                    ? AppCachedNetworkImage(
                        imageUrl: member.imageUrl!,
                        width: Spacing.familyDayMemberSelectorAvatarWidth,
                        height: Spacing.familyDayMemberSelectorAvatarHeight,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        member.imageAsset.isNotEmpty
                            ? member.imageAsset
                            : Assets.profileAvatar,
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
              Icon(
                Icons.check_circle_rounded,
                size: Spacing.familyDayMemberSelectorCheckSize,
                color: isSelected ? color.primary : color.outlineVariant,
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
