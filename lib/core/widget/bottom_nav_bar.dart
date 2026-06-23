import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable bottom navigation bar with custom styling.
/// ─────────────────────────────────────────────────────────────
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.type = BottomNavigationBarType.fixed,
    this.showLabels = true,
    this.elevation,
  });

  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final BottomNavigationBarType type;
  final bool showLabels;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: backgroundColor ?? AppColors.white,
        selectedItemColor: selectedItemColor ?? AppColors.primary,
        unselectedItemColor: unselectedItemColor ?? AppColors.textHint,
        selectedLabelStyle: selectedLabelStyle ??
            getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size11,
              color: AppColors.primary,
            ),
        unselectedLabelStyle: unselectedLabelStyle ??
            getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size11,
              color: AppColors.textHint,
            ),
        type: type,
        showSelectedLabels: showLabels,
        showUnselectedLabels: showLabels,
        elevation: elevation ?? 0,
        enableFeedback: true,
      ),
    );
  }
}