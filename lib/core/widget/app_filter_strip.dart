import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

/// Reusable segmented filter used by feature pages such as Offers and Calendar.
class AppFilterStrip extends StatelessWidget {
  const AppFilterStrip({
    super.key,
    required this.items,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    this.height = 46,
  });

  final List<AppFilterItem> items;
  final ValueChanged<int>? onTap;
  final EdgeInsetsGeometry padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: index == items.length - 1 ? 0 : 8,
                ),
                child: _FilterChip(
                  item: item,
                  onTap: onTap == null ? null : () => onTap!(index),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AppFilterItem {
  const AppFilterItem({
    required this.label,
    this.icon,
    this.isSelected = false,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.item, this.onTap});

  final AppFilterItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFF32983C);
    const unselectedColor = Color(0xFFC6E3D5);
    final foreground = item.isSelected
        ? AppColors.white
        : AppColors.primaryDarker;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: item.isSelected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: item.isSelected
                ? const [
                    BoxShadow(
                      color: unselectedColor,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.icon != null) ...[
                Icon(item.icon!, size: 16, color: foreground),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 14,
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
