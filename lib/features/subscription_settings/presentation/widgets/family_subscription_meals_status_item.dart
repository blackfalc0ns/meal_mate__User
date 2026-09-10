import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilySubscriptionMealsStatusItem extends StatelessWidget {
  const FamilySubscriptionMealsStatusItem({super.key, required this.status});

  final FamilySubscriptionMealStatusEntity status;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final statusColor = switch (status.status) {
      FamilySubscriptionMealStatus.completed => color.primary,
      FamilySubscriptionMealStatus.selected => color.secondary,
      FamilySubscriptionMealStatus.missing => color.onSurfaceVariant,
    };

    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            status.memberImageAsset,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 42),
          child: Text(
            status.memberName,
            locale: Locale(locale.localeName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurface,
            ),
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (status.status == FamilySubscriptionMealStatus.completed)
                    Icon(
                      Icons.check_circle,
                      size: 11,
                      color: statusColor,
                    )
                  else
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      status.statusLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    status.mealsLabel,
                    locale: Locale(locale.localeName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: status.status ==
                              FamilySubscriptionMealStatus.completed
                          ? color.primary
                          : color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadiusDirectional.circular(
                  Spacing.radiusPill,
                ),
                child: LinearProgressIndicator(
                  value: status.progress,
                  minHeight: 3.5,
                  backgroundColor: color.outlineVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
