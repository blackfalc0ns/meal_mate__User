part of 'calendar_meal_picker_sheet.dart';

class CalendarProteinLogo extends StatelessWidget {
  const CalendarProteinLogo({
    super.key,
    required this.size,
    required this.label,
    this.logoAsset,
    this.logoUrl,
  });

  final double size;
  final String label;
  final String? logoAsset;
  final String? logoUrl;

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
        child: logoUrl != null && logoUrl!.isNotEmpty
            ? AppCachedNetworkImage(
                imageUrl: logoUrl,
                fit: BoxFit.contain,
                shape: BoxShape.circle,
                semanticLabel: label,
              )
            : logoAsset == null
            ? Center(
                child: Text(
                  label,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
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
                      fontFamily: FontConstant.alexandria,
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
