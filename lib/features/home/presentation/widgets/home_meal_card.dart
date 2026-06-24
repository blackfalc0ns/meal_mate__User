import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';

class HomeMealCard extends StatelessWidget {
  const HomeMealCard({
    super.key,
    required this.meal,
  });

  final HomeMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = meal.statusLabel == 'الحالية';

    return Container(
      margin: const EdgeInsets.only(
        left: Spacing.base,
        right: Spacing.base,
        bottom: Spacing.md,
      ),
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFF0F7D35)
              : AppColors.border.withValues(alpha: 0.55),
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(meal.statusColor),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        meal.statusLabel,
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size11,
                          color: Color(meal.accentColor),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      meal.timeLabel,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size18,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  meal.title,
                  textAlign: TextAlign.right,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meal.subtitle,
                  textAlign: TextAlign.right,
                  style: getMediumStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                meal.imageAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
