import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarDeliveryDetailsSupportCard extends StatelessWidget {
  const CalendarDeliveryDetailsSupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return InkWell(
      onTap: () {
        unawaited(Navigator.of(context).pushNamed(AppRoutes.profileHelpCenter));
      },
      borderRadius: BorderRadius.circular(Spacing.cardRadius),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.cardPadding),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: Spacing.avatarSm + Spacing.sm,
              height: Spacing.avatarSm + Spacing.sm,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.primaryContainer.withValues(alpha: 0.4),
              ),
              child: Icon(
                Icons.support_agent_rounded,
                color: color.primary,
                size: Spacing.iconMd,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locale.calendar_delivery_need_help,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    locale.calendar_delivery_support_subtitle,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: Spacing.iconSm,
              color: color.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
