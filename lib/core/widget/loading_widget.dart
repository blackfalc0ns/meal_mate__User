import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';

/// ─────────────────────────────────────────────────────────────
/// Full-screen and inline loading indicators.
/// ─────────────────────────────────────────────────────────────
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message,
    this.size = 36.0,
    this.color,
    this.strokeWidth = 3.0,
  });

  /// Full-screen centered loader.
  const LoadingWidget.fullScreen({
    super.key,
    this.message,
    this.size = 36.0,
    this.color,
    this.strokeWidth = 3.0,
  });

  /// Inline small loader for use inside buttons / small spaces.
  const LoadingWidget.inline({
    super.key,
    this.size = 20.0,
    this.color,
    this.strokeWidth = 2.5,
  })  : message = null;

  final String? message;
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: color ?? AppColors.primary,
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              color: color ?? AppColors.primary,
            ),
          ),
          const SizedBox(height: Spacing.base),
          Text(
            message!,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}