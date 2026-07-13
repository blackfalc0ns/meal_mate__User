part of 'calendar_meal_picker_sheet.dart';

class _SourceSection extends StatelessWidget {
  const _SourceSection();

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
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 9,
              color: color.onSurface,
            ).copyWith(height: 20 / 9),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SourceCard(
                icon: Icons.set_meal_rounded,
                title: locale.calendar_meat,
                subtitle: locale.calendar_imported,
                country: locale.calendar_australia,
              ),
              _SourceCard(
                icon: Icons.egg_alt_rounded,
                title: locale.calendar_poultry,
                subtitle: locale.calendar_fresh_local,
                country: locale.calendar_local,
              ),
              _SourceCard(
                icon: Icons.phishing_rounded,
                title: locale.calendar_fish,
                subtitle: locale.calendar_imported,
                country: locale.calendar_norway,
              ),
              _SourceCard(
                icon: Icons.energy_savings_leaf_rounded,
                title: locale.calendar_oils,
                subtitle: locale.calendar_imported,
                country: locale.calendar_spain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
