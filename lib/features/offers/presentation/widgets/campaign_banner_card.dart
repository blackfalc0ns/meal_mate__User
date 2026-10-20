import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class CampaignBannerCard extends StatelessWidget {
  const CampaignBannerCard({super.key, required this.offer});

  final OfferEntity offer;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final languageCode = Localizations.localeOf(context).languageCode;
    final imageUrl = offer.bannerImageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.offersHeroRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: color.surfaceContainer),
          if (imageUrl != null && imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  ColoredBox(color: color.surfaceContainer),
            ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.sm),
              color: color.surface.withValues(alpha: 0.88),
              child: Text(
                offer.title(languageCode),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
