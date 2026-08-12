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
    final height = small
        ? Spacing.addressesHomeFormSmallFieldHeight
        : Spacing.addressesHomeFormFieldHeight;
    final iconBoxSize = small
        ? Spacing.addressesHomeFormSmallIconBoxSize
        : Spacing.addressesHomeFormIconBoxSize;
    final iconSize = small
        ? Spacing.addressesHomeFormSmallIconSize
        : Spacing.addressesHomeFormIconSize;
    final iconInset = small
        ? Spacing.addressesHomeFormSmallIconBoxInset
        : Spacing.addressesHomeFormIconBoxInset;
    final labelTop = small
        ? Spacing.addressesHomeFormSmallLabelTop
        : Spacing.addressesHomeFormLabelTop;
    final hintTop = small
        ? Spacing.addressesHomeFormSmallHintTop
        : Spacing.addressesHomeFormHintTop;
    final labelSize = small
        ? Spacing.addressesHomeFormSmallLabelSize
        : Spacing.addressesHomeFormLabelSize;
    final hintSize = small
        ? Spacing.addressesHomeFormSmallHintSize
        : Spacing.addressesHomeFormHintSize;
    final optionalSize = small
        ? Spacing.addressesHomeFormSmallOptionalSize
        : Spacing.addressesHomeFormOptionalSize;
    final arrowTop = small
        ? Spacing.addressesHomeFormSmallArrowTop
        : Spacing.addressesHomeFormArrowTop;
    final textWidth = small
        ? Spacing.addressesHomeFormSmallTextWidth
        : Spacing.addressesHomeFormTextWidth;

    final isInput = !showDropdown;
    final displayValue = value ?? hint;
    final hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: Spacing.addressesHomeFormFieldWidth,
        height: height,
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
        child: Stack(
          children: [
            PositionedDirectional(
              start: iconInset,
              top: iconInset,
              child: Container(
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
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormTextEnd,
              top: labelTop,
              width: textWidth,
              child: Text(
                label,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: labelSize,
                  color: color.onSurfaceVariant,
                ),
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormTextEnd,
              top: hintTop,
              width: textWidth,
              child: isInput
                  ? SizedBox(
                      height: height - hintTop,
                      child: TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        textInputAction: textInputAction,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        cursorColor: color.primary,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: hintSize,
                          color: color.onSurface,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: hint,
                          hintStyle: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: hintSize,
                            color: color.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text(
                      displayValue,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: hintSize,
                        color: hasValue
                            ? color.onSurface
                            : color.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
            ),
            if (showDropdown)
              PositionedDirectional(
                end: Spacing.addressesHomeFormArrowStart,
                top: arrowTop,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: Spacing.addressesHomeFormSmallIconSize,
                  color: color.onSurfaceVariant,
                  semanticLabel: locale.addresses_choose_location_title,
                ),
              ),
            if (optionalText != null)
              PositionedDirectional(
                end: Spacing.addressesHomeFormOptionalStart,
                top: Spacing.addressesHomeFormOptionalTop,
                child: Text(
                  optionalText!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: optionalSize,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
