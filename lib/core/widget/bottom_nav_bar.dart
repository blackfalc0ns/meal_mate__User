import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';

/// Bottom navigation bar that uses the native iOS 26 Liquid Glass effect
/// on supported iOS devices, and falls back to a frosted-glass widget
/// on Android and older iOS.
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
    // NativeGlassNavBar uses SF Symbols (iOS only).
    // Items are reversed for RTL layout in the fallback;
    // the native bar handles its own ordering.
    final nativeTabs = items.map((item) {
      return NativeGlassNavBarItem(
        label: item.label,
        symbol: item.sfSymbol ?? 'circle.fill',
      );
    }).toList();

    return NativeGlassNavBar(
      tabs: nativeTabs,
      currentIndex: currentIndex,
      onTap: onTap,
      tintColor: AppColors.primaryVariant,
      fallback: _FrostedNavBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}

// ── Frosted-glass fallback (Android + unsupported iOS) ───────────

class _FrostedNavBar extends StatelessWidget {
  const _FrostedNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppBottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.55),
                  Colors.white.withValues(alpha: 0.80),
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 0.8,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64,
                child: Row(
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    final isActive = i == currentIndex;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTap(i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primaryVariant
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                isActive
                                    ? (item.selectedIcon ?? item.icon)
                                    : item.icon,
                                size: 22,
                                color: isActive
                                    ? Colors.white
                                    : const Color(0xFF555555),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: 10.5,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isActive
                                    ? AppColors.primaryVariant
                                    : const Color(0xFF555555),
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Data model ───────────────────────────────────────────────────

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

  /// SF Symbol name for the native iOS tab bar.
  /// e.g. 'house.fill', 'fork.knife', 'flame.fill'
  final String? sfSymbol;
  final bool isAnimated;
}
