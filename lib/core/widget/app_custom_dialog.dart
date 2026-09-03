import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AppCustomDialog {
  AppCustomDialog._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String confirmText,
    required String cancelText,
    required T Function() onConfirm,
    required T Function() onCancel,
    String? message,
    Widget? content,
    IconData? icon,
    Color? iconColor,
    Color? confirmTextColor,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool useSafeArea = true,
  }) {
    final color = Theme.of(context).colorScheme;

    return WoltModalSheet.show<T>(
      context: context,
      useSafeArea: useSafeArea,
      barrierDismissible: barrierDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      modalBarrierColor: color.scrim,
      modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
      pageListBuilder: (modalContext) {
        final modalColor = Theme.of(modalContext).colorScheme;

        return [
          WoltModalSheetPage(
            backgroundColor: modalColor.surface,
            surfaceTintColor: modalColor.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.screenH,
                //    vertical: Spacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (icon != null) ...[
                    ExcludeSemantics(
                      child: Icon(
                        icon,
                        color: iconColor ?? modalColor.primary,
                        size: Spacing.iconXl,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                  ],
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size15,
                      color: modalColor.onSurface,
                    ),
                  ),
                  if (message != null && message.isNotEmpty) ...[
                    const SizedBox(height: Spacing.sm),
                    Text(
                      message,
                      textAlign: TextAlign.start,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: modalColor.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (content != null) ...[
                    const SizedBox(height: Spacing.sm),
                    content,
                  ],
                  const SizedBox(height: Spacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(modalContext).pop(onCancel());
                        },
                        child: Text(
                          cancelText,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: modalColor.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      TextButton(
                        onPressed: () {
                          Navigator.of(modalContext).pop(onConfirm());
                        },
                        child: Text(
                          confirmText,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: confirmTextColor ?? modalColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}
