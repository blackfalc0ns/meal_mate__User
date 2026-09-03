import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_period_filter_chip.dart';

class InfluencerPeriodFilterStrip extends StatelessWidget {
  const InfluencerPeriodFilterStrip({
    super.key,
    required this.periods,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < periods.length; index++) ...[
            InfluencerPeriodFilterChip(
              label: periods[index],
              selected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
            if (index != periods.length - 1)
              const SizedBox(width: Spacing.influencerStatsPeriodGap),
          ],
        ],
      ),
    );
  }
}
