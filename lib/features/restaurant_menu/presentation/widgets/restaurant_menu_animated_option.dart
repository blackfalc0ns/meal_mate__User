part of 'restaurant_menu_view.dart';

class RestaurantMenuAnimatedOption extends StatefulWidget {
  const RestaurantMenuAnimatedOption({
    super.key,
    required this.child,
    required this.animateEntry,
    this.delay = Duration.zero,
    this.onAnimated,
  });

  final Widget child;
  final bool animateEntry;
  final Duration delay;
  final VoidCallback? onAnimated;

  @override
  State<RestaurantMenuAnimatedOption> createState() =>
      _RestaurantMenuAnimatedOptionState();
}

class _RestaurantMenuAnimatedOptionState
    extends State<RestaurantMenuAnimatedOption> {
  @override
  void initState() {
    super.initState();
    if (widget.animateEntry) {
      widget.onAnimated?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animateEntry || MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return widget.child
        .animate()
        .fadeIn(
          delay: widget.delay,
          duration: 260.ms,
          curve: Curves.easeOutCubic,
        )
        .slideY(
          begin: 0.06,
          end: 0,
          delay: widget.delay,
          duration: 260.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
