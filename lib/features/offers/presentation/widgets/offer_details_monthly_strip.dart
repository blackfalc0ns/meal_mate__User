import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class OfferDetailsMonthlyStrip extends StatelessWidget {
  const OfferDetailsMonthlyStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: const [
              _PagerDot(active: true),
              SizedBox(width: 8),
              _PagerDot(),
              SizedBox(width: 8),
              _PagerDot(),
              SizedBox(width: 8),
              _PagerDot(),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            textDirection: TextDirection.rtl,
            children: const [
              Expanded(
                child: _QuickFilterChip(
                  label: 'الكل',
                  icon: Icons.local_fire_department_rounded,
                  selected: true,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _QuickFilterChip(
                  label: 'العروض',
                  icon: Icons.local_offer_rounded,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _QuickFilterChip(
                  label: 'المطاعم',
                  icon: Icons.restaurant_rounded,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _QuickFilterChip(
                  label: 'اشتراكات',
                  icon: Icons.inventory_2_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PagerDot extends StatelessWidget {
  const _PagerDot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primaryDark : const Color(0xFFC9E0CD),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _QuickFilterChip extends StatelessWidget {
  const _QuickFilterChip({
    required this.label,
    required this.icon,
    this.selected = false,
  });

  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final background = selected ? AppColors.primary : const Color(0xFFDDEBD9);
    final foreground = selected ? AppColors.white : const Color(0xFF2D3A31);

    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 14,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
