import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_entity.dart';

class FamilyMemberSelectedMealItem extends StatelessWidget {
  const FamilyMemberSelectedMealItem({
    super.key,
    required this.meal,
    required this.showDivider,
  });

  final FamilyCalendarSelectedMealEntity meal;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        SizedBox(
          height: Spacing.familyMemberCalendarSelectedMealRowHeight,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  Spacing.familyMemberCalendarSelectedMealImageRadius,
                ),
                child: meal.imageUrl?.isNotEmpty == true
                    ? AppCachedNetworkImage(
                        imageUrl: meal.imageUrl!,
                        width: Spacing.familyMemberCalendarSelectedMealImageSize,
                        height: Spacing.familyMemberCalendarSelectedMealImageSize,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        meal.imageAsset.isNotEmpty
                            ? meal.imageAsset
                            : Assets.profileBillingPlanBottle,
                        width: Spacing.familyMemberCalendarSelectedMealImageSize,
                        height: Spacing.familyMemberCalendarSelectedMealImageSize,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: Spacing.xs),
              SizedBox(
                width: Spacing.familyMemberCalendarSelectedMealTypeWidth,
                height: Spacing.familyMemberCalendarSelectedMealTypeHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.tertiaryContainer,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Center(
                    child: Text(
                      meal.typeLabel,
                      locale: Locale(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size7,
                        color: color.onTertiaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      locale: Locale(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      meal.description,
                      locale: Locale(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              SizedBox(
                width: Spacing.familyMemberCalendarChosenPillWidth,
                height: Spacing.familyMemberCalendarChosenPillHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.primaryContainer,
                    border: Border.all(color: color.primaryContainer),
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: Spacing.iconSm,
                        color: color.primary,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Flexible(
                        child: Text(
                          meal.chosenLabel,
                          locale: Locale(locale.localeName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size7,
                            color: color.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: Spacing.border,
            thickness: Spacing.border,
            color: color.outlineVariant,
          ),
      ],
    );
  }
}
