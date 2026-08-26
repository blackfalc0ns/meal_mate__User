part of 'calendar_meal_picker_sheet.dart';

class CalendarSourceSection extends StatelessWidget {
  const CalendarSourceSection({super.key, this.origins = const []});

  final List<SubscriptionRestaurantIngredientOriginEntity> origins;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (origins.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _cards(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _cards(BuildContext context) {
    final locale = context.localization;
    if (origins.isEmpty) {
      return const [];
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

    return ordered.take(4).map((origin) {
      return CalendarSourceCard(
        icon: _iconFor(origin.category),
        title: origin.name(locale.localeName),
        subtitle: origin.source(locale.localeName),
        country: origin.originCountryName(locale.localeName),
      );
    }).toList();
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
}
