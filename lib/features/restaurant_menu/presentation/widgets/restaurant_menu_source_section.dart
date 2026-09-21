part of 'restaurant_menu_view.dart';

class RestaurantMenuSourceSection extends StatelessWidget {
  const RestaurantMenuSourceSection({
    super.key,
    this.coreIngredients = const [],
    this.origins = const [],
    this.isLoading = false,
  });

  final List<CalendarCoreIngredientEntity> coreIngredients;
  final List<SubscriptionRestaurantIngredientOriginEntity> origins;
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

    if (coreIngredients.isEmpty && origins.isEmpty) {
      return const SizedBox.shrink();
    }

    final cards = _cards(context);

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
              for (var index = 0; index < cards.length; index++) ...[
                if (index > 0) const SizedBox(width: Spacing.base),
                cards[index],
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _cards(BuildContext context) {
    final locale = context.localization;
    if (coreIngredients.isNotEmpty) {
      return coreIngredients.map((ingredient) {
        return RestaurantMenuSourceCard(
          icon: Icons.eco_rounded,
          iconUrl: ingredient.iconUrl,
          title: ingredient.name,
          subtitle: ingredient.isLocal
              ? locale.calendar_fresh_local
              : locale.calendar_imported,
          country: _countryLabel(ingredient),
        );
      }).toList();
    }

    final ordered = [...origins]
      ..sort((a, b) {
        const order = ['meat', 'poultry', 'seafood', 'oils'];
        final aIndex = order.indexOf(a.category);
        final bIndex = order.indexOf(b.category);
        return (aIndex == -1 ? order.length : aIndex).compareTo(
          bIndex == -1 ? order.length : bIndex,
        );
      });

    return ordered.map((origin) {
      return RestaurantMenuSourceCard(
        icon: _iconFor(origin.category),
        iconUrl: origin.iconUrl,
        title: origin.name(locale.localeName),
        subtitle: origin.source(locale.localeName),
        country: origin.originCountryName(locale.localeName),
      );
    }).toList();
  }

  String _countryLabel(CalendarCoreIngredientEntity ingredient) {
    final country = ingredient.originCountryName;
    final flag = ingredient.flagEmoji;
    if (flag == null || flag.isEmpty) return country;
    if (country.isEmpty) return flag;
    return '$flag $country';
  }

  IconData _iconFor(String category) {
    return switch (category) {
      'meat' => Icons.set_meal_rounded,
      'poultry' => Icons.egg_alt_rounded,
      'seafood' => Icons.phishing_rounded,
      'oils' => Icons.energy_savings_leaf_rounded,
      'grains' => Icons.rice_bowl_rounded,
      'produce' => Icons.spa_rounded,
      'dairy' => Icons.local_drink_rounded,
      _ => Icons.eco_rounded,
    };
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
