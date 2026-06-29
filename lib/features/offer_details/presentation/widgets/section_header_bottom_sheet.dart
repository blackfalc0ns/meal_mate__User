import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class SectionHeaderBottomSheet extends StatelessWidget {
  const SectionHeaderBottomSheet({
    super.key,
    required this.offer,
    this.onClose,
  });

  final OfferDealEntity offer;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final discountLabel =
        offer.discountLabel.isNotEmpty ? offer.discountLabel : '20%';
    final heroImage = offer.imageAsset.isNotEmpty
        ? offer.imageAsset
        : 'assets/images/offers/grilled_plate.png';
    final titleLine1 = offer.detailTitle ?? offer.title;
    final titleLine2 = offer.detailSubtitle ?? offer.subtitle;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top bar: X + title
            SizedBox(
              height: 34,
              child: Stack(
                children: [
                  if (onClose != null)
                    Positioned(
                      left: 0,
                      child: InkResponse(
                        onTap: onClose,
                        radius: 24,
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.close_rounded,
                            size: 28,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      offer.badgeLabel.isNotEmpty
                          ? offer.badgeLabel
                          : '$discountLabel على ${offer.title}',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Hero row: image on left (LTR left = RTL right visually) + text on right
            Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image on the left
                _PlateHero(
                  imageAsset: heroImage,
                  accentColor: offer.accentColor,
                ),
                const SizedBox(width: 12),
                // Text on the right
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'خصم',
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          discountLabel,
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: 40,
                            color: offer.accentColor,
                          ),
                        ),
                        Text(
                          titleLine1,
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          titleLine2,
                          style: getRegularStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlateHero extends StatelessWidget {
  const _PlateHero({required this.imageAsset, required this.accentColor});

  final String imageAsset;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Leaf dots
          Positioned(
            right: -6,
            top: 10,
            child: _LeafDot(size: 14, color: accentColor.withValues(alpha: 0.35)),
          ),
          Positioned(
            right: 10,
            top: -4,
            child: _LeafDot(size: 10, color: accentColor.withValues(alpha: 0.25)),
          ),
          Positioned(
            left: -4,
            bottom: 20,
            child: _LeafDot(size: 12, color: accentColor.withValues(alpha: 0.28)),
          ),
          Positioned(
            left: 10,
            bottom: 6,
            child: _LeafDot(size: 9, color: accentColor.withValues(alpha: 0.20)),
          ),
          Positioned(
            right: 2,
            bottom: 8,
            child: _LeafDot(size: 8, color: accentColor.withValues(alpha: 0.18)),
          ),
          // Circle image
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 138,
              height: 138,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: ClipOval(
                child: Image.asset(imageAsset, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeafDot extends StatelessWidget {
  const _LeafDot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
