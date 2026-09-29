import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddressFormField extends StatelessWidget {
  const AddressFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.iconAsset,
    this.showDropdown = false,
    this.value,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
    this.optionalText,
    this.small = false,
    this.hasError = false,
  });

  final String label;
  final String hint;
  final String iconAsset;
  final bool showDropdown;
  final String? value;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final String? optionalText;
  final bool small;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    const height = Spacing.addressesHomeFormCompactFieldHeight;
    const iconBoxSize = Spacing.addressesHomeFormSmallIconBoxSize;
    const iconSize = Spacing.addressesHomeFormSmallIconSize;
    final labelSize = small ? FontSize.size11 : FontSize.size12;
    final hintSize = small ? FontSize.size13 : FontSize.size14;
    final optionalSize = small
        ? Spacing.addressesHomeFormSmallOptionalSize
        : FontSize.size11;

    final isInput = !showDropdown;
    final displayValue = value ?? hint;
    final hasValue = value != null && value!.isNotEmpty;
    final labelStyle = getSemiBoldStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: labelSize,
      color: color.onSurfaceVariant,
    ).copyWith(height: 1.1);
    final optionalStyle = getRegularStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: optionalSize,
      color: color.onSurfaceVariant.withValues(alpha: 0.8),
    ).copyWith(height: 1.1);
    final inputTextStyle = getMediumStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: hintSize,
      color: color.onSurface,
    ).copyWith(height: 1.2);
    final inputHintStyle = getRegularStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: hintSize,
      color: color.onSurfaceVariant.withValues(alpha: 0.6),
    ).copyWith(height: 1.2);
    final displayTextStyle = getMediumStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: hintSize,
      color: hasValue
          ? color.onSurface
          : color.onSurfaceVariant.withValues(alpha: 0.6),
    ).copyWith(height: 1.2);
    final textStrutStyle = StrutStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: hintSize,
      height: 1.2,
      forceStrutHeight: true,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(
            color: hasError ? color.error : color.outlineVariant,
            width: Spacing.hairline,
          ),
          borderRadius: BorderRadius.circular(
            Spacing.buttonRadius,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: iconBoxSize,
              height: iconBoxSize,
              decoration: BoxDecoration(
                color: color.secondaryContainer,
                borderRadius: BorderRadius.circular(
                  Spacing.buttonSmallRadius,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconAsset,
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: labelSize,
                            height: 1,
                            forceStrutHeight: true,
                          ),
                          style: labelStyle,
                        ),
                      ),
                      if (optionalText != null)
                        Text(
                          optionalText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: optionalSize,
                            height: 1,
                            forceStrutHeight: true,
                          ),
                          style: optionalStyle,
                        ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Row(
                    children: [
                      Expanded(
                        child: isInput
                            ? TextField(
                                controller: controller,
                                keyboardType: keyboardType,
                                textInputAction: textInputAction,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                cursorColor: color.primary,
                                strutStyle: textStrutStyle,
                                style: inputTextStyle,
                                decoration: InputDecoration(
                                  hintText: hint,
                                  hintStyle: inputHintStyle,
                                  isCollapsed: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(
                                    Spacing.zero,
                                  ),
                                  filled: false,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                              )
                            : Text(
                                displayValue,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                strutStyle: textStrutStyle,
                                style: displayTextStyle,
                              ),
                      ),
                      if (showDropdown)
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: Spacing.iconSm,
                          color: color.onSurfaceVariant,
                          semanticLabel: locale.addresses_choose_location_title,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
