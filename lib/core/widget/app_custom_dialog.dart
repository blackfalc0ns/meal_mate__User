import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_loading_button.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AppCustomDialog {
  AppCustomDialog._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String confirmText,
    String? cancelText,
    required T Function() onConfirm,
    T Function()? onCancel,
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
        final modalColor = modalContext.colorScheme;
        final primaryColor = confirmTextColor ?? modalColor.primary;

        return [
          WoltModalSheetPage(
            hasTopBarLayer: false,
            navBarHeight: Spacing.zero,
            backgroundColor: modalColor.surface,
            surfaceTintColor: modalColor.surface,
            child: Padding(
              padding: const EdgeInsets.only(
                left: Spacing.screenH,
                right: Spacing.screenH,
                top: Spacing.lg,
                bottom: Spacing.base,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (icon != null) ...[
                    Center(
                      child: Container(
                        width: Spacing.iconXl + Spacing.sm,
                        height: Spacing.iconXl + Spacing.sm,
                        decoration: BoxDecoration(
                          color: (iconColor ?? primaryColor).withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          color: iconColor ?? primaryColor,
                          size: Spacing.xxl,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                  ],
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size16,
                      color: modalColor.onSurface,
                    ),
                  ),
                  if (message != null && message.isNotEmpty) ...[
                    const SizedBox(height: Spacing.sm),
                    Text(
                      message,
                      textAlign: message.contains('\n')
                          ? TextAlign.start
                          : TextAlign.center,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: modalColor.onSurfaceVariant,
                      ).copyWith(height: 1.5),
                    ),
                  ],
                  if (content != null) ...[
                    const SizedBox(height: Spacing.md),
                    content,
                  ],
                  const SizedBox(height: Spacing.lg),
                  Builder(
                    builder: (_) {
                      final hasCancel =
                          cancelText != null && cancelText.trim().isNotEmpty;
                      final confirmBtn = AppLoadingButton(
                        height: Spacing.buttonSmallHeight,
                        text: confirmText,
                        color: primaryColor,
                        textColor: modalColor.onPrimary,
                        fontSize: FontSize.size13,
                        borderRadius: Spacing.buttonRadius,
                        onPressed: () {
                          Navigator.of(modalContext).pop(onConfirm());
                        },
                      );

                      if (!hasCancel) {
                        return SizedBox(
                          width: double.infinity,
                          child: confirmBtn,
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: confirmBtn),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: SizedBox(
                              height: Spacing.buttonSmallHeight,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: modalColor.outlineVariant,
                                    width: Spacing.border,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      Spacing.buttonRadius,
                                    ),
                                  ),
                                  backgroundColor: modalColor.surface,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.sm,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(modalContext).pop(
                                    onCancel?.call(),
                                  );
                                },
                                child: Text(
                                  cancelText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size13,
                                    color: modalColor.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
