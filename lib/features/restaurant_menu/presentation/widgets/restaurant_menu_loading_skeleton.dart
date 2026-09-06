part of 'restaurant_menu_view.dart';

class RestaurantMenuLoadingSkeleton extends StatelessWidget {
  const RestaurantMenuLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.only(start: Spacing.base),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: ShimmerPlaceholder.rect(
                width: 120,
                height: 22,
                borderRadius: Spacing.xs,
              ),
            ),
          ),
          const SizedBox(height: Spacing.base),
          ...List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == 2 ? Spacing.zero : Spacing.xl,
              ),
              child: const Row(
                textDirection: TextDirection.rtl,
                children: [
                  ShimmerPlaceholder.rect(
                    width: 108,
                    height: 108,
                    borderRadius: Spacing.md,
                  ),
                  SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShimmerPlaceholder.rect(width: 180, height: 18),
                        SizedBox(height: Spacing.md),
                        Row(
                          children: [
                            Expanded(child: ShimmerPlaceholder.rect(height: 14)),
                            SizedBox(width: Spacing.sm),
                            Expanded(child: ShimmerPlaceholder.rect(height: 14)),
                            SizedBox(width: Spacing.sm),
                            Expanded(child: ShimmerPlaceholder.rect(height: 14)),
                          ],
                        ),
                        SizedBox(height: Spacing.md),
                        ShimmerPlaceholder.rect(width: 92, height: 14),
                        SizedBox(height: Spacing.sm),
                        Row(
                          children: [
                            ShimmerPlaceholder.rect(width: 66, height: 24),
                            SizedBox(width: Spacing.sm),
                            ShimmerPlaceholder.rect(width: 66, height: 24),
                            SizedBox(width: Spacing.sm),
                            ShimmerPlaceholder.rect(width: 66, height: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
