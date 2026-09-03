import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AppLoadingButton extends StatefulWidget {
  const AppLoadingButton({
    required this.text,
    super.key,
    this.controller,
    this.onPressed,
    this.color,
    this.textColor,
    this.disabledColor,
    this.successColor,
    this.errorColor,
    this.valueColor,
    this.height = Spacing.buttonSmallHeight,
    this.width = double.infinity,
    this.borderRadius = Spacing.buttonRadius,
    this.elevation = Spacing.zero,
    this.animateOnTap = false,
    this.resetAfterDuration = false,
    this.icon,
    this.iconWidget,
    this.textStyle,
    this.fontSize,
  });

  final String text;
  final RoundedLoadingButtonController? controller;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final Color? disabledColor;
  final Color? successColor;
  final Color? errorColor;
  final Color? valueColor;
  final double height;
  final double width;
  final double borderRadius;
  final double elevation;
  final bool animateOnTap;
  final bool resetAfterDuration;
  final IconData? icon;
  final Widget? iconWidget;
  final TextStyle? textStyle;
  final double? fontSize;

  @override
  State<AppLoadingButton> createState() => _AppLoadingButtonState();
}

class _AppLoadingButtonState extends State<AppLoadingButton> {
  late RoundedLoadingButtonController _controller;
  bool _createdInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = RoundedLoadingButtonController();
      _createdInternalController = true;
    }
  }

  @override
  void didUpdateWidget(covariant AppLoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (widget.controller != null) {
        _controller = widget.controller!;
        _createdInternalController = false;
      } else if (!_createdInternalController) {
        _controller = RoundedLoadingButtonController();
        _createdInternalController = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final buttonColor = widget.color ?? color.primary;
    final textClr = widget.textColor ?? color.onPrimary;

    final resolvedStyle = widget.textStyle ??
        getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: widget.fontSize ?? FontSize.size13,
          color: textClr,
        );

    final childWidget = (widget.icon != null || widget.iconWidget != null)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.iconWidget ??
                  Icon(
                    widget.icon,
                    size: Spacing.base,
                    color: textClr,
                  ),
              const SizedBox(width: Spacing.xs),
              Text(
                widget.text,
                style: resolvedStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          )
        : Text(
            widget.text,
            style: resolvedStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedWidth = widget.width.isInfinite
            ? constraints.maxWidth
            : widget.width;

        return RoundedLoadingButton(
          controller: _controller,
          onPressed: widget.onPressed,
          animateOnTap: widget.animateOnTap,
          resetAfterDuration: widget.resetAfterDuration,
          height: widget.height,
          width: resolvedWidth,
          borderRadius: widget.borderRadius,
          elevation: widget.elevation,
          color: buttonColor,
          successColor: widget.successColor ?? buttonColor,
          errorColor: widget.errorColor ?? color.error,
          disabledColor: widget.disabledColor ?? color.outlineVariant,
          valueColor: widget.valueColor ?? textClr,
          child: childWidget,
        );
      },
    );
  }
}
