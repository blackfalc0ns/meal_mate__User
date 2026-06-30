import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarQuickActions extends StatelessWidget {
  const CalendarQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Column(
        children: [
          Row(
            children: [
            
              Expanded(
                child: _ActionButton(
                  label: l10n.calendar_change_meal,
                  icon: Icons.refresh_rounded,
                  color: AppColors.calendarAccent,
                ),
              ),
                            const SizedBox(width: 20),

                Expanded(
                child: _ActionButton(
                  label: l10n.calendar_pause,
                  icon: Icons.pause_presentation_rounded,
                  color: AppColors.calendarActionBrown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
             
              Expanded(
                child: _ActionButton(
                  label: l10n.calendar_add_meal,
                  icon: Icons.add_rounded,
                  color: AppColors.calendarAccent,
                ),
              ),
                            const SizedBox(width: 20),

               Expanded(
                child: _ActionButton(
                  label: l10n.calendar_reschedule,
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.calendarError,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.calendarSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.calendarSoftBorder),
        boxShadow: const [
          BoxShadow(color: AppColors.calendarLightShadow, blurRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 21, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.ibmPlexSansArabic,
            ),
          ),
        ],
      ),
    );
  }
}
