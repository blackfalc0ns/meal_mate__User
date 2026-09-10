import 'package:flutter/material.dart';

class StaggeredSlideItem extends StatefulWidget {
  const StaggeredSlideItem({
    super.key,
    required this.index,
    required this.child,
    this.delayStepMs = 60,
    this.slideDurationMs = 340,
    this.beginOffset,
  });

  final int index;
  final Widget child;
  final int delayStepMs;
  final int slideDurationMs;
  final Offset? beginOffset;

  @override
  State<StaggeredSlideItem> createState() => _StaggeredSlideItemState();
}

class _StaggeredSlideItemState extends State<StaggeredSlideItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    final delayMs = widget.index * widget.delayStepMs;
    final totalDurationMs = widget.slideDurationMs + delayMs;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalDurationMs),
    );

    final startFraction =
        totalDurationMs > 0 ? (delayMs / totalDurationMs).clamp(0.0, 0.95) : 0.0;

    _curve = CurvedAnimation(
      parent: _controller,
      curve: Interval(startFraction, 1.0, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(startFraction, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final defaultOffset = Offset(isRtl ? 0.22 : -0.22, 0.0);
    final slideAnimation = Tween<Offset>(
      begin: widget.beginOffset ?? defaultOffset,
      end: Offset.zero,
    ).animate(_curve);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: widget.child,
      ),
    );
  }
}
