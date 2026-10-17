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
    this.onBackToHome,
    this.onBackToCalendar,
    this.onRateExperience,
    this.onReportIssue,
  });

  final VoidCallback? onBackToHome;
  final VoidCallback? onBackToCalendar;
  final VoidCallback? onRateExperience;
  final VoidCallback? onReportIssue;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final backCallback = onBackToHome ?? onBackToCalendar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          text: locale.calendar_delivery_back_to_home,
          onPressed: backCallback,
          icon: Icons.home_rounded,
          iconBeforeText: true,
          height: Spacing.buttonHeight,
          borderRadius: 28.0,
          color: color.primary,
          textColor: color.onPrimary,
          fontSize: FontSize.size15,
        ),
        const SizedBox(height: Spacing.md),
        AppButton.outlined(
          text: locale.calendar_delivery_rate_experience,
          onPressed:
              onRateExperience ??
              () {
                unawaited(
                  Navigator.of(context).pushNamed(AppRoutes.profileComplaints),
                );
              },
          icon: Icons.star_rounded,
          iconBeforeText: true,
          height: Spacing.buttonHeight,
          borderRadius: 28.0,
          color: color.primary,
          textColor: color.primary,
          fontSize: FontSize.size15,
        ),
        const SizedBox(height: Spacing.xs),
        TextButton.icon(
          onPressed:
              onReportIssue ??
              () {
                unawaited(
                  Navigator.of(context).pushNamed(AppRoutes.profileComplaints),
                );
              },
          icon: Icon(
            Icons.info_outline_rounded,
            size: Spacing.iconSm,
            color: color.primary,
          ),
          label: Text(
            locale.calendar_delivery_report_issue,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.primary,
            ),
          ),
        ),
      ],
    );
  }
}
