import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class SectionHeaderButtonSheet extends StatelessWidget {
  const SectionHeaderButtonSheet({
    super.key,
    required this.offer,
    this.onClose,
  });

  final OfferDealEntity offer;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final isMonthlyOffer = offer.couponCode == 'SAVE20';

    if (!isMonthlyOffer) {
      return _GenericHeader(offer: offer, onClose: onClose);
    }

    final discountLabel = offer.discountLabel.isNotEmpty
        ? offer.discountLabel
        : '20%';
    final heroImage = offer.imageAsset.isNotEmpty
        ? offer.imageAsset
        : 'assets/images/offers/grilled_plate.png';

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 34,
            child: Stack(
              children: [
                if (onClose != null)
                  PositionedDirectional(
                    start: 0,
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
                    'خصم $discountLabel على الباقات الشهرية',
                    textAlign: TextAlign.center,
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
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خصم',
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        discountLabel,
                        textAlign: TextAlign.end,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: 36,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'على الباقات الشهرية',
                        textAlign: TextAlign.end,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'خطط غذائية متكاملة\nتساعدك على تحقيق أهدافك',

                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _PlateHero(imageAsset: heroImage),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenericHeader extends StatelessWidget {
  const _GenericHeader({required this.offer, required this.onClose});

  final OfferDealEntity offer;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final discountLabel = offer.discountLabel.isNotEmpty
        ? offer.discountLabel
        : 'خصم';

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 2, end: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discountLabel,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size24,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    offer.title,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onClose != null)
            InkResponse(
              onTap: onClose,
              radius: 24,
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.close_rounded,
                  size: 28,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlateHero extends StatelessWidget {
  const _PlateHero({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      height: 176,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            start: -6,
            top: 12,
            child: _LeafDot(
              size: 18,
              color: AppColors.primary.withValues(alpha: 0.32),
            ),
          ),
          PositionedDirectional(
            start: 0,
            bottom: 18,
            child: _LeafDot(
              size: 16,
              color: AppColors.primary.withValues(alpha: 0.24),
            ),
          ),
          PositionedDirectional(
            end: -2,
            top: 24,
            child: _LeafDot(
              size: 14,
              color: AppColors.primary.withValues(alpha: 0.18),
            ),
          ),
          PositionedDirectional(
            end: 10,
            bottom: 10,
            child: _LeafDot(
              size: 12,
              color: AppColors.primary.withValues(alpha: 0.16),
            ),
          ),
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
                    color: AppColors.shadow.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
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
