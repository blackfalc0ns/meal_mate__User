import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferBrowseCard extends StatelessWidget {
  const OfferBrowseCard({
    super.key,
    required this.offer,
    required this.onTap,
    this.onActionTap,
  });

  final OfferEntity offer;
  final VoidCallback onTap;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    final isUnknown = offer.purchaseMode == OfferPurchaseMode.unknown;

    return InkWell(
      onTap: isUnknown ? null : onTap,
      borderRadius: BorderRadius.circular(Spacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Spacing.md),
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail / Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(Spacing.sm),
              child: Container(
                width: 80,
                height: 80,
                color: color.primary.withValues(alpha: 0.08),
                child:
                    offer.bannerImageUrl != null &&
                        offer.bannerImageUrl!.isNotEmpty
                    ? Image.network(
                        offer.bannerImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.local_offer_rounded,
                          color: color.primary,
                          size: 36,
                        ),
                      )
                    : Icon(
                        Icons.local_offer_rounded,
                        color: color.primary,
                        size: 36,
                      ),
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          offer.title(lang),
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (offer.formattedDiscount().isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            offer.formattedDiscount(),
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    offer.description(lang),
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (offer.remainingSpots != null)
                        Text(
                          '${offer.remainingSpots} ${locale.offer_browse_remaining_spots}',
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.outline,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (!isUnknown)
                        InkWell(
                          onTap: onActionTap ?? onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.primary,
                              borderRadius: BorderRadius.circular(Spacing.xs),
                            ),
                            child: Text(
                              locale.offer_browse_action_button,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: color.onPrimary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
