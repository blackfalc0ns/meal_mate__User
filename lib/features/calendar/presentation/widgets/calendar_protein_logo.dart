part of 'calendar_meal_picker_sheet.dart';

class CalendarProteinLogo extends StatelessWidget {
  const CalendarProteinLogo({
    super.key,
    required this.size,
    required this.label,
    this.logoAsset,
  });

  final double size;
  final String label;
  final String? logoAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: '${locale.calendar_restaurant_name}: $label',
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(Spacing.xs),
        decoration: BoxDecoration(
          color: color.inverseSurface,
          shape: BoxShape.circle,
        ),
        child: logoAsset == null
            ? Center(
                child: Text(
                  label,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: size * 0.159,
                    color: color.onInverseSurface,
                  ).copyWith(height: 1),
                ),
              )
            : Image.asset(
                logoAsset!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: size * 0.159,
                      color: color.onInverseSurface,
                    ).copyWith(height: 1),
                  ),
                ),
              ),
      ),
    );
  }
}
