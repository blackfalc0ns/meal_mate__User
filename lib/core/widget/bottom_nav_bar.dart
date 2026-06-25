import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppBottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
      Spacing.base,
        Spacing.base,
        Spacing.sm,
      ),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.16),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;
            return Expanded(
              child: _BottomNavItemTile(
                item: item,
                isSelected: isSelected,
                onTap: () => onTap(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AppBottomNavBarItem {
  const AppBottomNavBarItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.isAnimated = false,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final bool isAnimated;
}

class _BottomNavItemTile extends StatelessWidget {
  const _BottomNavItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final AppBottomNavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, isSelected ? -8 : 0, 0),
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
        horizontal: isSelected ? 6 : 0,
        vertical: isSelected ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarySurface : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.16),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: SizedBox(
        width: isSelected ? 68 : double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavIcon(item: item, isSelected: isSelected),
            const SizedBox(height: 2),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size10,
                color: isSelected ? AppColors.primaryDarker : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.item, required this.isSelected});

  final AppBottomNavBarItem item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (item.isAnimated) {
      return SizedBox(
        width: 40,
        height: 40,
        child: Lottie.asset(
          Assets.fireAnimation,
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
        ),
      );
    }

    return Icon(
      isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
      size: 26,
      color: isSelected ? AppColors.primaryDarker : AppColors.black,
    );
  }
}
