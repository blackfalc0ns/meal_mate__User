part of 'restaurant_menu_view.dart';

class RestaurantMenuSourceSection extends StatelessWidget {
  const RestaurantMenuSourceSection({
    super.key,
    this.origins = const [],
    this.isLoading = false,
  });

  final List<RestaurantMenuOrigin> origins;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: ShimmerPlaceholder.rect(
                width: 140,
                height: 14,
                borderRadius: Spacing.xs,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: [
                  for (var index = 0; index < 4; index++) ...[
                    if (index > 0) const SizedBox(width: Spacing.base),
                    _shimmerCard(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (origins.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          locale.calendar_ingredient_origin_title,
          textAlign: TextAlign.start,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < origins.length; index++) ...[
                if (index > 0) const SizedBox(width: Spacing.base),
                RestaurantMenuSourceCard(
                  icon: origins[index].icon,
                  iconUrl: origins[index].iconUrl,
                  title: origins[index].title,
                  subtitle: origins[index].subtitle,
                  country: origins[index].country,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerCard(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: Spacing.restaurantDetailsSourceCardWidth,
      height: Spacing.restaurantDetailsSourceCardHeight,
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.hairline,
        ),
      ),
      child: const Column(
        children: [
          ShimmerPlaceholder.circle(size: 20),
          Expanded(
            child: Center(
              child: ShimmerPlaceholder.rect(
                width: 44,
                height: 10,
                borderRadius: Spacing.xs,
              ),
            ),
          ),
          ShimmerPlaceholder.rect(
            width: 52,
            height: 14,
            borderRadius: Spacing.radiusXs,
          ),
        ],
      ),
    );
  }
}
