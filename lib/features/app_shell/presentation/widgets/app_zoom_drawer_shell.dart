import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/features/app_shell/presentation/widgets/meal_mate_drawer_menu.dart';

class AppZoomDrawerShell extends StatefulWidget {
  const AppZoomDrawerShell({
    super.key,
    required this.child,
    required this.userName,
    required this.greeting,
    required this.avatarAsset,
  });

  final Widget child;
  final String userName;
  final String greeting;
  final String avatarAsset;

  @override
  State<AppZoomDrawerShell> createState() => _AppZoomDrawerShellState();
}

class _AppZoomDrawerShellState extends State<AppZoomDrawerShell> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final slideWidth = size.width;

    return ZoomDrawer(
      controller: _drawerController,
      isRtl: true,
      menuScreenWidth: double.infinity,
      slideWidth: slideWidth,
      borderRadius: 38,
      angle: 0,
      mainScreenScale: 1,
      menuBackgroundColor: AppColors.drawerBackground,
      drawerShadowsBackgroundColor: AppColors.white.withValues(alpha: 0.25),
      showShadow: true,
      mainScreenTapClose: true,
      androidCloseOnBackTap: true,
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 300),
      openCurve: Curves.easeOutCubic,
      closeCurve: Curves.easeInOutCubic,
      menuScreen: const SizedBox.shrink(),
      mainScreen: DrawerControllerScope(
        controller: _drawerController,
        child: ColoredBox(color: AppColors.background, child: widget.child),
      ),
      drawerStyleBuilder: (context, animationValue, width, menu, main) {
        final screenSize = MediaQuery.sizeOf(context);
        final radius = 38.2 * animationValue;
        final scale = ui.lerpDouble(1, 254.74 / 393, animationValue)!;
        final offsetX = ui.lerpDouble(
          0,
          -(screenSize.width * 76 / 393),
          animationValue,
        )!;
        final offsetY = ui.lerpDouble(
          0,
          screenSize.height * 162.86 / 852,
          animationValue,
        )!;

        return Stack(
          fit: StackFit.expand,
          children: [
            MealMateDrawerMenu(
              animationValue: animationValue,
              controller: _drawerController,
              userName: widget.userName,
              greeting: widget.greeting,
              avatarAsset: widget.avatarAsset,
            ),
            Transform.translate(
              offset: Offset(offsetX, offsetY),
              child: Transform.scale(
                alignment: Alignment.topLeft,
                scale: scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(
                            alpha: 0.18 * animationValue,
                          ),
                          blurRadius: 22 * animationValue,
                          offset: Offset(0, 12 * animationValue),
                        ),
                      ],
                    ),
                    child: DrawerAnimationScope(
                      animationValue: animationValue,
                      child: main,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DrawerAnimationScope extends InheritedWidget {
  const DrawerAnimationScope({
    super.key,
    required this.animationValue,
    required super.child,
  });

  final double animationValue;

  static double maybeOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<DrawerAnimationScope>()
            ?.animationValue ??
        0;
  }

  @override
  bool updateShouldNotify(DrawerAnimationScope oldWidget) {
    return oldWidget.animationValue != animationValue;
  }
}

class DrawerControllerScope extends InheritedWidget {
  const DrawerControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final ZoomDrawerController controller;

  static ZoomDrawerController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DrawerControllerScope>()
        ?.controller;
  }

  static void openDrawer(BuildContext context) {
    final controller = maybeOf(context);
    if (controller?.isOpen?.call() == true) return;
    controller?.open?.call();
  }

  static void closeDrawer(BuildContext context) {
    final controller = maybeOf(context);
    if (controller?.isOpen?.call() != true) return;
    controller?.close?.call();
  }

  @override
  bool updateShouldNotify(DrawerControllerScope oldWidget) {
    return oldWidget.controller != controller;
  }
}
