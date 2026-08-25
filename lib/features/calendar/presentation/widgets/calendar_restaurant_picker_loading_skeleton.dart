part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantPickerLoadingSkeleton extends StatelessWidget {
  const CalendarRestaurantPickerLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 9.2),
      itemBuilder: (context, index) {
        return SizedBox(
          height: 74.22,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.46),
              border: Border.all(
                color: context.colorScheme.outlineVariant,
                width: 1.55,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.5,
                vertical: Spacing.sm,
              ),
              child: Row(
                children: [
                  ShimmerPlaceholder.circle(size: 46),
                  SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShimmerPlaceholder.rect(width: 132, height: 13),
                        SizedBox(height: Spacing.xs),
                        ShimmerPlaceholder.rect(width: 188, height: 10),
                        SizedBox(height: Spacing.xs),
                        ShimmerPlaceholder.rect(width: 74, height: 10),
                      ],
                    ),
                  ),
                  SizedBox(width: Spacing.md),
                  ShimmerPlaceholder.circle(size: 46),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
