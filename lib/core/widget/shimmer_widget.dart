import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';

/// ─────────────────────────────────────────────────────────────
/// Shimmer loading placeholder for skeleton screens.
/// ─────────────────────────────────────────────────────────────
class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor ?? AppColors.shimmerBase,
                widget.highlightColor ?? AppColors.shimmerHighlight,
                widget.baseColor ?? AppColors.shimmerBase,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform:
                  _SlidingGradientTransform(slidePercent: _animation.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});
  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

/// ─────────────────────────────────────────────────────────────
/// Pre-built shimmer placeholders for common layouts.
/// ─────────────────────────────────────────────────────────────
class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  }) : size = null;

  /// Rectangular shimmer block.
  const ShimmerPlaceholder.rect({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.margin,
  }) : size = null;

  /// Circular shimmer (avatar).
  const ShimmerPlaceholder.circle({
    super.key,
    this.size = Spacing.avatarMd,
    this.margin,
  })  : width = null,
        height = null,
        borderRadius = null;

  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  /// For circle variant.
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (size != null) {
      // Circle variant
      return ShimmerWidget(
        child: Container(
          margin: margin,
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.shimmerBase,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return ShimmerWidget(
      child: Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius ?? Spacing.sm),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// Full card shimmer for list loading states.
/// ─────────────────────────────────────────────────────────────
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
      itemBuilder: (context, index) {
        return ShimmerWidget(
          child: Container(
            padding: const EdgeInsets.all(Spacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
            ),
            child: Row(
              children: [
                const ShimmerPlaceholder.circle(size: 48),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity * 0.6,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Container(
                        height: 12,
                        width: double.infinity * 0.4,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}