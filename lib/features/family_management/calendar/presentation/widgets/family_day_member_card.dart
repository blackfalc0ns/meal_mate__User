import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_status_chip.dart';

class FamilyDayMemberCard extends StatelessWidget {
  const FamilyDayMemberCard({super.key, required this.member});

  final FamilyDayMemberEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.familyDayMemberCardHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(
            color: color.outlineVariant,
            width: Spacing.familyDayMealCardBorderWidth,
          ),
          borderRadius: BorderRadius.circular(
            Spacing.familyDayMemberCardRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familyDayMemberContentPadding,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  Spacing.familyDayMemberAvatarRadius,
                ),
                child: member.imageUrl?.isNotEmpty == true
                    ? AppCachedNetworkImage(
                        imageUrl: member.imageUrl!,
                        width: Spacing.familyDayMemberAvatarWidth,
                        height: Spacing.familyDayMemberAvatarHeight,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        member.imageAsset.isNotEmpty
                            ? member.imageAsset
                            : Assets.profileAvatar,
                        width: Spacing.familyDayMemberAvatarWidth,
                        height: Spacing.familyDayMemberAvatarHeight,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: Spacing.md),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    locale: Locale(locale.localeName),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size16,
                      color: color.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    member.ageLabel,
                    locale: Locale(locale.localeName),
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              FamilyDayStatusChip(label: member.statusLabel),
            ],
          ),
        ),
      ),
    );
  }
}
