import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanViewModeHeader extends StatelessWidget {
  const MonthlyPlanViewModeHeader({
    super.key,
    required this.mode,
    required this.onModeChanged,
  });

  final SubscriptionPlanViewMode mode;
  final ValueChanged<SubscriptionPlanViewMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'طريقة العرض',
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size11,
            color: AppColors.appTextMuted,
          ),
        ),
        const Spacer(),
        _ModeIconButton(
          icon: Icons.grid_view_rounded,
          selected: mode == SubscriptionPlanViewMode.grid,
          onTap: () => onModeChanged(SubscriptionPlanViewMode.grid),
        ),
        const SizedBox(width: Spacing.xs),
        _ModeIconButton(
          icon: Icons.view_list_rounded,
          selected: mode == SubscriptionPlanViewMode.list,
          onTap: () => onModeChanged(SubscriptionPlanViewMode.list),
        ),
      ],
    );
  }
}

class _ModeIconButton extends StatelessWidget {
  const _ModeIconButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusXs),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: selected ? 1.12 : 1,
        child: Icon(
          icon,
          size: selected ? 19 : 16,
          color: selected ? AppColors.primary : AppColors.appTextMuted,
        ),
      ),
    );
  }
}
