import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';

class HomeMealCard extends StatelessWidget {
  const HomeMealCard({super.key, required this.meal});

  final HomeMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final isCurrent = meal.statusLabel == 'الحالية';

    return Padding(
      padding: const EdgeInsets.only(left: 31, right: 31, bottom: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: isCurrent ? 1 : 0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isCurrent
                    ? const Color(0xFF006D40)
                    : const Color(0xFFE1E3E4),
                width: isCurrent ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(
                    alpha: isCurrent ? 0.10 : 0.05,
                  ),
                  blurRadius: isCurrent ? 6 : 2,
                  offset: Offset(0, isCurrent ? 4 : 1),
                ),
              ],
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEEEF),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.05),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(meal.imageAsset, fit: BoxFit.cover),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          _StatusPill(
                            label: meal.statusLabel,
                            isCurrent: isCurrent,
                          ),
                          const Spacer(),
                          Text(
                            '${meal.categoryTitle} • ${meal.timeLabel}',
                            textAlign: TextAlign.right,
                            style: getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size14,
                              color: const Color(0xFF006D40),
                            ).copyWith(height: 20 / 14, letterSpacing: 0.28),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.title,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size18,
                          color: const Color(0xFF191C1D),
                        ).copyWith(height: 26 / 18),
                      ),
                      const SizedBox(height: 4),
                      isCurrent
                          ? Row(
                              textDirection: TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _MacroChip(label: meal.subtitle),
                                const SizedBox(width: 8),
                                _MacroChip(label: '${meal.caloriesLabel} سعرة'),
                              ],
                            )
                          : Text(
                              '${meal.caloriesLabel} سعرة حرارية',
                              textAlign: TextAlign.right,
                              style: getRegularStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size12,
                                color: const Color(0xFF5D5E68),
                              ).copyWith(height: 16 / 12),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: -10,
            child: _TimelineDot(isCurrent: isCurrent),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.isCurrent});

  final String label;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFF006D40) : const Color(0x4D48AD75),
        borderRadius: BorderRadius.circular(9999),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size10,
          color: isCurrent ? AppColors.white : const Color(0xFF006D40),
        ).copyWith(height: 1.5),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: getRegularStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size12,
          color: const Color(0xFF59413D),
        ).copyWith(height: 16 / 12),
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.isCurrent});

  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCurrent ? 24 : 20,
      height: isCurrent ? 24 : 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFF0C6C3F) : const Color(0xFF006D40),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFF8F9FA), width: 4),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: const Color(0xFF0C6C3F).withValues(alpha: 0.5),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: isCurrent
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            )
          : const Icon(Icons.check_rounded, size: 9, color: AppColors.white),
    );
  }
}
