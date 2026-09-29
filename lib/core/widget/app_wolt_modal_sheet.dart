import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AppWoltModalSheet {
  AppWoltModalSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    Widget? titleWidget,
    Widget? stickyActionBar,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool hasTopBarLayer = true,
    bool isTopBarLayerAlwaysVisible = true,
    bool useSafeArea = true,
    double? navBarHeight,
    Widget? leadingNavBarWidget,
    Widget? trailingNavBarWidget,
    VoidCallback? onClose,
  }) {
    final color = context.colorScheme;

    return WoltModalSheet.show<T>(
      context: context,
      useSafeArea: useSafeArea,
      barrierDismissible: barrierDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      modalBarrierColor: color.scrim.withValues(alpha: 0.35),
      modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
      pageListBuilder: (modalContext) {
        final modalColor = modalContext.colorScheme;
        final resolvedTitleWidget =
            titleWidget ??
            (title != null
                ? Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: modalColor.onSurface,
                    ),
                  )
                : null);

        return [
          WoltModalSheetPage(
            backgroundColor: modalColor.surface,
            surfaceTintColor: modalColor.surface,
            navBarHeight:
                navBarHeight ?? (hasTopBarLayer ? null : Spacing.zero),
            hasTopBarLayer: hasTopBarLayer,
            isTopBarLayerAlwaysVisible: isTopBarLayerAlwaysVisible,
            topBarTitle: resolvedTitleWidget,
            trailingNavBarWidget:
                trailingNavBarWidget ??
                (hasTopBarLayer
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed:
                            onClose ?? () => Navigator.of(modalContext).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: modalColor.onSurfaceVariant,
                          size: Spacing.iconMd,
                        ),
                      )
                    : null),
            leadingNavBarWidget: leadingNavBarWidget,
            stickyActionBar: stickyActionBar,
            child: child,
          ),
        ];
      },
    );
  }

  static Future<T?> showPages<T>({
    required BuildContext context,
    required List<WoltModalSheetPage> Function(BuildContext modalContext)
    pageListBuilder,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool useSafeArea = true,
  }) {
    final color = context.colorScheme;

    return WoltModalSheet.show<T>(
      context: context,
      useSafeArea: useSafeArea,
      barrierDismissible: barrierDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      modalBarrierColor: color.scrim.withValues(alpha: 0.35),
      modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
      pageListBuilder: pageListBuilder,
    );
  }
}
