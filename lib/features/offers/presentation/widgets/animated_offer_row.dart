import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';

class AnimatedOfferRow extends StatefulWidget {
  const AnimatedOfferRow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<AnimatedOfferRow> createState() => _AnimatedOfferRowState();
}

class _AnimatedOfferRowState extends State<AnimatedOfferRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    unawaited(_controller.forward());
  }

  @override
  void didUpdateWidget(covariant AnimatedOfferRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemCount != widget.itemCount) {
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Spacing.offersDealRowHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.offersHorizontalPadding,
        ),

        scrollDirection: Axis.horizontal,
        itemCount: widget.itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.base),
        itemBuilder: (context, index) {
          final start = (index * 0.08).clamp(0.0, 0.48);
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(start, 1, curve: Curves.easeOutBack),
          );

          return AnimatedBuilder(
            animation: animation,
            child: widget.itemBuilder(context, index),
            builder: (context, child) {
              final value = animation.value;
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset((1 - value) * Spacing.xxl, 0),
                  child: Transform.scale(
                    scale: 0.92 + (value * 0.08),
                    child: child,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
