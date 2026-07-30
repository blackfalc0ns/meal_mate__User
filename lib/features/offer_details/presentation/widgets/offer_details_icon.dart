import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';

class OfferDetailsIcon extends StatelessWidget {
  const OfferDetailsIcon({
    super.key,
    required this.type,
    required this.size,
    required this.tint,
  });

  final OfferDetailsIconType type;
  final double size;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Icon(
      _iconData,
      color: tint,
      size: size,
      semanticLabel: locale.app_brand_name,
      shadows: [
        Shadow(color: color.shadow.withValues(alpha: 0.05), blurRadius: 0),
      ],
    );
  }

  IconData get _iconData {
    return switch (type) {
      OfferDetailsIconType.tag => Icons.local_offer_rounded,
      OfferDetailsIconType.calendar => Icons.calendar_month_rounded,
      OfferDetailsIconType.target => Icons.track_changes_rounded,
      OfferDetailsIconType.box => Icons.inventory_2_rounded,
      OfferDetailsIconType.document => Icons.article_rounded,
      OfferDetailsIconType.copy => Icons.copy_rounded,
      OfferDetailsIconType.sliders => Icons.tune_rounded,
      OfferDetailsIconType.money => Icons.savings_outlined,
    };
  }
}
