part of 'calendar_meal_picker_sheet.dart';

class CalendarSourceSection extends StatelessWidget {
  const CalendarSourceSection({this.origins = const []});

  final List<SubscriptionRestaurantIngredientOriginEntity> origins;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 39, end: 39),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.calendar_ingredient_origin_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 2),
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
      return [
        CalendarSourceCard(
          icon: Icons.set_meal_rounded,
          title: locale.calendar_meat,
          subtitle: locale.calendar_imported,
          country: locale.calendar_australia,
        ),
        CalendarSourceCard(
          icon: Icons.egg_alt_rounded,
          title: locale.calendar_poultry,
          subtitle: locale.calendar_fresh_local,
          country: locale.calendar_local,
        ),
        CalendarSourceCard(
          icon: Icons.phishing_rounded,
          title: locale.calendar_fish,
          subtitle: locale.calendar_imported,
          country: locale.calendar_norway,
        ),
        CalendarSourceCard(
          icon: Icons.energy_savings_leaf_rounded,
          title: locale.calendar_oils,
          subtitle: locale.calendar_imported,
          country: locale.calendar_spain,
        ),
      ];
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
