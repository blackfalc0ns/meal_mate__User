import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';

/// Floating bottom navigation used by the main app shell.
///
/// Its dimensions, colours and spacing mirror the `tabPills` bottom bar in
/// the MealMate Figma file (node 25:3590).
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.activeBackground,
  });

  final List<AppBottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeBackground;

  static const _activeColor = Color(0xFF0C6C3F);
  static const _inactiveColor = Color(0xFF191C1D);
  static const _activeBackground = Color(0xB3E6E6E6);

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
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x24000000),
                    offset: Offset(0, 2),
                    blurRadius: 20,
                  ),
                  BoxShadow(
                    color: Color(0x33FFFFFF),
                    offset: Offset(0, -1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.38),
                        width: 1,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.42),
                          Colors.white.withValues(alpha: 0.14),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        height: 66,
                        child: Row(
                          children: List.generate(items.length, (index) {
                            return Expanded(
                              child: _NavItem(
                                key: items[index].itemKey,
                                item: items[index],
                                selected: index == currentIndex,
                                activeColor: activeColor ?? _activeColor,
                                inactiveColor:
                                    inactiveColor ?? _inactiveColor,
                                activeBackground:
                                    activeBackground ?? _activeBackground,
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
    super.key,
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
    final visualIconSize = item.iconSize.clamp(0, 34).toDouble();

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: selected ? activeBackground : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: selected
                    ? Border.all(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 1,
                      )
                    : null,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.24),
                          offset: const Offset(0, -1),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 34,
                    child: Center(
                      child: SizedBox.square(
                        dimension: visualIconSize,
                        child: item.animationAsset != null
                            ? Lottie.asset(
                                item.animationAsset!,
                                fit: BoxFit.contain,
                                repeat: true,
                              )
                            : item.svgAsset != null
                            ? SvgPicture.asset(
                                item.svgAsset!,
                                fit: BoxFit.contain,
                                colorFilter: item.tintSvg
                                    ? ColorFilter.mode(
                                        foreground,
                                        BlendMode.srcIn,
                                      )
                                    : null,
                              )
                            : Icon(
                                selected
                                    ? (item.selectedIcon ?? item.icon)
                                    : item.icon,
                                size: visualIconSize,
                                color: foreground,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBottomNavBarItem {
  const AppBottomNavBarItem({
    this.itemKey,
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.svgAsset,
    this.animationAsset,
    this.tintSvg = true,
    this.iconSize = 24,
    this.sfSymbol,
    this.isAnimated = false,
  });

  final Key? itemKey;
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final String? svgAsset;
  final String? animationAsset;
  final bool tintSvg;
  final double iconSize;

  /// Kept for compatibility with existing navigation item declarations.
  final String? sfSymbol;
  final bool isAnimated;
}
