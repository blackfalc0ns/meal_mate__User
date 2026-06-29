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
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final String largeAsset;
  final String smallAsset;

  @override
  Widget build(BuildContext context) {
    return size == AppButtonSize.small
        ? _buildSmall(context)
        : _buildLarge(context);
  }

  // ── Small: SVG + نص متمركز بتعويض الـ drop-shadow (4px أسفل) ──
  Widget _buildSmall(BuildContext context) {
    final h = height ?? 32.0;

    return SizedBox(
      width: isExpanded ? double.infinity : width,
      height: h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: isLoading ? null : onPressed,
          child: Stack(
            children: [
              // الـ SVG يملأ كل المساحة
              Positioned.fill(
                child: SvgPicture.asset(smallAsset, fit: BoxFit.fill),
              ),
              // النص يتمركز في الـ shape الفعلية (بدون 4px shadow في الأسفل)
              Positioned.fill(
                bottom: 4,
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: textColor,
                          ),
                        )
                      : _buildLabel(FontSize.size12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Large: SVG background ─────────────────────────────────
  Widget _buildLarge(BuildContext context) {
    final h = height ?? 56.0;

    return SizedBox(
      width: isExpanded ? double.infinity : width,
      height: h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(largeAsset, fit: BoxFit.fill),
              ),
              Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 20),
                child: isLoading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: textColor,
                        ),
                      )
                    : _buildLabel(FontSize.size16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Shared label ──────────────────────────────────────────
  Widget _buildLabel(double fontSize) {
    final style = getBoldStyle(
      fontSize: fontSize,
      fontFamily: FontConstant.ibmPlexSansArabic,
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
