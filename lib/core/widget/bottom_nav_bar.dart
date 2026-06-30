import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';

/// Floating bottom navigation used by the main app shell.
///
/// Its dimensions, colours and spacing mirror the `mainContainer` tab bar in
/// the MealMate Figma file (node 28:4416).
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

  static const _activeColor = Color(0xFF0C6C3F);
  static const _inactiveColor = Color(0xFF191C1D);
  static const _activeBackground = Color(0xFFE6E6E6);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 354),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: ColoredBox(
                      // The Figma bar is a translucent glass layer, not an
                      // opaque white navigation surface.
                      color: Colors.white.withValues(alpha: 0.45),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: List.generate(items.length, (index) {
                            return Expanded(
                              child: _NavItem(
                                item: items[index],
                                selected: index == currentIndex,
                                activeColor: _activeColor,
                                inactiveColor: _inactiveColor,
                                activeBackground: _activeBackground,
                                onTap: () => onTap(index),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeBackground,
    required this.onTap,
  });

  final AppBottomNavBarItem item;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBackground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? activeColor : inactiveColor;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected ? activeBackground : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? (item.selectedIcon ?? item.icon) : item.icon,
                  size: 24,
                  color: foreground,
                ),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
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
    this.sfSymbol,
    this.isAnimated = false,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;

  /// Kept for compatibility with existing navigation item declarations.
  final String? sfSymbol;
  final bool isAnimated;
}
