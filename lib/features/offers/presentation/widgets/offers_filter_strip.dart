import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersFilterStrip extends StatelessWidget {
  const OffersFilterStrip({super.key, required this.filters, this.onTap});

  final List<OfferFilterEntity> filters;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: Row(
          children: List.generate(filters.length, (index) {
            final filter = filters[index];
            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: index == filters.length - 1 ? 0 : Spacing.sm,
                ),
                child: _FilterChip(
                  label: filter.label,
                  icon: _iconForLabel(filter.label, index),
                  isSelected: filter.isSelected,
                  onTap: onTap == null ? null : () => onTap!(index),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  IconData _iconForLabel(String label, int index) {
    final normalized = label.trim();
    if (normalized == 'الكل' || normalized == 'All') {
      return Icons.local_fire_department_rounded;
    }
    if (normalized == 'العروض' || normalized == 'Offers') {
      return Icons.local_offer_rounded;
    }
    if (normalized == 'المطاعم' || normalized == 'Restaurants') {
      return Icons.restaurant_rounded;
    }
    if (normalized == 'الوجبات' || normalized == 'Meals') {
      return Icons.restaurant_menu_rounded;
    }

    return index.isEven ? Icons.local_offer_rounded : Icons.restaurant_rounded;
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final background = isSelected
        ? AppColors.primary
        : AppColors.primarySurface;
    final foreground = isSelected ? AppColors.white : AppColors.primaryDarker;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size14,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
