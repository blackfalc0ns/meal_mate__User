import 'package:flutter/material.dart';

class CalendarDeliveryTimelineConnector extends StatelessWidget {
  const CalendarDeliveryTimelineConnector({
    super.key,
    required this.isDashed,
    required this.color,
  });

  final bool isDashed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (!isDashed) {
      return Container(
        height: 1.5,
        color: color,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.maxWidth;
        if (boxWidth <= 0 || !boxWidth.isFinite) {
          return const SizedBox.shrink();
        }
        const dashWidth = 3.5;
        const dashSpace = 2.5;
        final count = (boxWidth / (dashWidth + dashSpace)).floor();
        if (count <= 0) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(0.5),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
