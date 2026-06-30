import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarProgressCard extends StatelessWidget {
  const CalendarProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsetsDirectional.fromSTEB(18, 18, 42, 18),
      constraints: const BoxConstraints(minHeight: 162),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.calendarCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarCardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.calendar_month_progress,
                  style: getBoldStyle(
                    fontSize: 24,
                    fontFamily: FontConstant.ibmPlexSansArabic,
                  ),
                ),
                Text(
                  l10n.calendar_month_progress_value,
                  style: getRegularStyle(
                    fontSize: 18,
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    color: AppColors.calendarProgressText,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.calendarProgressBadge,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.sentiment_satisfied_alt_rounded,
                        size: 20,
                        color: AppColors.calendarAccentDark,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.calendar_commitment,
                        style: getSemiBoldStyle(
                          fontSize: 14,
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          color: AppColors.calendarAccentDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 8,
                    color: AppColors.primaryDark,
                    backgroundColor: AppColors.calendarProgressTrack,
                  ),
                ),
                Text(
                  '100%',
                  style: getBoldStyle(
                    fontSize: 18,
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    color: AppColors.calendarProgress,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
