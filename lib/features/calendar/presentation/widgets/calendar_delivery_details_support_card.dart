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
      borderRadius: BorderRadius.circular(Spacing.base),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.cardPadding),
        decoration: BoxDecoration(
          color: color.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Spacing.base),
          border: Border.all(
            color: color.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.primary.withValues(alpha: 0.12),
              ),
              child: Icon(
                Icons.headset_mic_rounded,
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
                    style: getBoldStyle(
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
            const SizedBox(width: Spacing.xs),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              size: Spacing.iconSm,
              color: color.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
