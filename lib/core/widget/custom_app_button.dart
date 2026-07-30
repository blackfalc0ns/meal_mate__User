import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

enum AppButtonSize { small, large }

class CustomAppButton extends StatelessWidget {
  const CustomAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.iconWidget,
    this.size = AppButtonSize.large,
    this.height,
    this.width,
    this.textColor = Colors.white,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.largeAsset = 'assets/images/svg/button_large.svg',
    this.smallAsset = 'assets/images/svg/button_small.svg',
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final Widget? iconWidget;
  final AppButtonSize size;
  final double? height;
  final double? width;
  final Color textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;

  // Kept for backward compatibility with existing callers.
  final String largeAsset;
  final String smallAsset;

  @override
  Widget build(BuildContext context) {
    final isSmall = size == AppButtonSize.small;
    final buttonHeight = height ?? (isSmall ? 40.0 : 35.0);
    final asset = isSmall ? smallAsset : largeAsset;

    return SizedBox(
      width: isExpanded ? double.infinity : width,
      height: buttonHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  asset,
                  fit: BoxFit.fill,
                  clipBehavior: Clip.antiAlias,
                ),
              ),
              Padding(
                padding:
                    padding ??
                    EdgeInsets.symmetric(horizontal: isSmall ? 12 : 20),
                child: isLoading
                    ? SizedBox.square(
                        dimension: isSmall ? 14 : 22,
                        child: CircularProgressIndicator(
                          strokeWidth: isSmall ? 2 : 2.4,
                          color: textColor,
                        ),
                      )
                    : _buildLabel(
                        fontSize ??
                            (isSmall ? FontSize.size12 : FontSize.size16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(double fontSize) {
    final style = getBoldStyle(
      fontSize: fontSize,
      fontFamily: FontConstant.alexandria,
      color: textColor,
    ).copyWith(fontWeight: fontWeight ?? FontWeight.w700);

    if (icon != null || iconWidget != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              style: style,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          iconWidget ?? Icon(icon, color: textColor, size: 18),
        ],
      );
    }

    return Text(
      text,
      style: style,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
