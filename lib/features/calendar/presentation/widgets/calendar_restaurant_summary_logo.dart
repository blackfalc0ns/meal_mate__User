part of 'calendar_restaurant_summary_card.dart';

class CalendarRestaurantSummaryLogo extends StatelessWidget {
  const CalendarRestaurantSummaryLogo({
    super.key,
    this.logoUrl,
    this.semanticLabel,
  });

  final String? logoUrl;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    const size = 44.0;

    if (logoUrl != null &&
        logoUrl!.isNotEmpty &&
        !logoUrl!.contains('default')) {
      return AppCachedNetworkImage(
        imageUrl: logoUrl,
        width: size,
        height: size,
        shape: BoxShape.circle,
        semanticLabel: semanticLabel,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DIET',
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onSurface,
                ).copyWith(height: 1),
              ),
              const SizedBox(width: 1),
              Icon(Icons.eco_rounded, color: color.primary, size: 10),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            'HOUSE',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size8,
              color: color.onSurface,
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
