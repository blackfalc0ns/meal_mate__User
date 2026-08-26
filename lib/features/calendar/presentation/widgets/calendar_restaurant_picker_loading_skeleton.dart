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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.5,
                vertical: Spacing.sm,
              ),
              child: Row(
                children: [
                  const ShimmerPlaceholder.circle(size: 46),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        ShimmerPlaceholder.rect(width: 132, height: 13),
                        SizedBox(height: Spacing.xs),
                        ShimmerPlaceholder.rect(width: 188, height: 10),
                        SizedBox(height: Spacing.xs),
                        ShimmerPlaceholder.rect(width: 74, height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  const ShimmerPlaceholder.circle(size: 46),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
