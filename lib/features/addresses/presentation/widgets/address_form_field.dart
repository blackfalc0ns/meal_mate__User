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

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final height = Spacing.addressesHomeFormCompactFieldHeight;
    final iconBoxSize = Spacing.addressesHomeFormSmallIconBoxSize;
    final iconSize = Spacing.addressesHomeFormSmallIconSize;
    final iconInset = small
        ? Spacing.addressesHomeFormSmallIconBoxInset
        : Spacing.sm;
    final labelSize = small ? FontSize.size15 : FontSize.size16;
    final hintSize = small ? FontSize.size17 : FontSize.size18;
    final optionalSize = small
        ? Spacing.addressesHomeFormSmallOptionalSize
        : Spacing.addressesHomeFormOptionalSize;

    final isInput = !showDropdown;
    final displayValue = value ?? hint;
    final hasValue = value != null && value!.isNotEmpty;
    final labelStyle = getSemiBoldStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: labelSize,
      color: color.onSurfaceVariant,
    ).copyWith(height: 1);
    final optionalStyle = getRegularStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: optionalSize,
      color: color.onSurfaceVariant,
    ).copyWith(height: 1);
    final inputTextStyle = getRegularStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: hintSize,
      color: color.onSurface,
    ).copyWith(height: 1);
    final inputHintStyle = getRegularStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: hintSize,
      color: color.onSurfaceVariant.withValues(alpha: 0.7),
    ).copyWith(height: 1);
    final displayTextStyle = getRegularStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: hintSize,
      color: hasValue
          ? color.onSurface
          : color.onSurfaceVariant.withValues(alpha: 0.7),
    ).copyWith(height: 1);
    final textStrutStyle = StrutStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: hintSize,
      height: 1,
      forceStrutHeight: true,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: height,
        padding: EdgeInsetsDirectional.all(iconInset),
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(
            color: color.outlineVariant,
            width: Spacing.addressesHomeFormFieldBorder,
          ),
          borderRadius: BorderRadius.circular(
            Spacing.addressesHomeFormFieldRadius,
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
                  Spacing.addressesHomeFormIconBoxRadius,
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
            const SizedBox(width: Spacing.base),
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
                  const SizedBox(height: Spacing.base),
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
                          size: Spacing.iconMd,
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
