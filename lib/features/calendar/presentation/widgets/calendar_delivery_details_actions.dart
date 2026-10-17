import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class CalendarDeliveryDetailsActions extends StatelessWidget {
  const CalendarDeliveryDetailsActions({
    super.key,
    required this.onBackToCalendar,
  });

  final VoidCallback onBackToCalendar;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          text: locale.calendar_delivery_back_to_calendar,
          onPressed: onBackToCalendar,
          height: Spacing.buttonHeight,
          borderRadius: Spacing.buttonRadius,
          color: color.primary,
          textColor: color.onPrimary,
          fontSize: FontSize.size14,
        ),
        const SizedBox(height: Spacing.sm),
        AppButton(
          text: locale.calendar_delivery_rate_experience,
          onPressed: () {
            unawaited(
              Navigator.of(context).pushNamed(AppRoutes.profileComplaints),
            );
          },
          height: Spacing.buttonHeight,
          borderRadius: Spacing.buttonRadius,
          color: color.surfaceContainerHighest,
          textColor: color.onSurface,
          fontSize: FontSize.size14,
        ),
        const SizedBox(height: Spacing.xs),
        TextButton(
          onPressed: () {
            unawaited(
              Navigator.of(context).pushNamed(AppRoutes.profileComplaints),
            );
          },
          child: Text(
            locale.calendar_delivery_report_issue,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.error,
            ),
          ),
        ),
      ],
    );
  }
}
