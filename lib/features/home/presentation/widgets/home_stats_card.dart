import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({
    super.key,
    required this.progress,
    required this.dailyCalories,
    required this.goalCalories,
  });

  final double progress;
  final int dailyCalories;
  final int goalCalories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _ProgressRing(progress: progress),
            ),
          ),
          Container(width: 1, height: 52, color: AppColors.divider),
     
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'السعرات اليومية',
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    NumberFormat.decimalPattern('en').format(dailyCalories),
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size30,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'من ${NumberFormat.decimalPattern('en').format(goalCalories)} سعرة',
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1,
            strokeWidth: 7.5,
            color: AppColors.secondary.withValues(alpha: 0.18),
            backgroundColor: AppColors.secondary.withValues(alpha: 0.18),
          ),
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 7.5,
            strokeCap: StrokeCap.round,
            color: AppColors.secondary,
            backgroundColor: Colors.transparent,
          ),
          Text(
            '${(progress * 100).round()}%',
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size24,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
