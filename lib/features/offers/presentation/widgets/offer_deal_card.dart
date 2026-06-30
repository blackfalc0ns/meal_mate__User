import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_button.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OfferDealCard extends StatelessWidget {
  const OfferDealCard({super.key, required this.offer, this.onTap});

  final OfferDealEntity offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 111,
          height: 188,
          padding: const EdgeInsets.fromLTRB(7, 7, 7, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [offer.surfaceColor, AppColors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: offer.accentColor.withValues(alpha: 0.16),
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 56,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 78,
                        height: 52,
                        child: Image.asset(
                          offer.imageAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  if (offer.badgeLabel.isNotEmpty) ...[
                    _Badge(label: offer.badgeLabel, color: offer.accentColor),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    offer.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size11,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    offer.subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  SizedBox(
                    height: 23,
                    child: AppButton(
                      fontWeight: FontWeight.w700,
                      fontSize: FontSize.size11,
                      height: 23,
                      text: offer.buttonLabel,
                      onPressed: onTap,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      if (offer.deliveryPrefixLabel != null) ...[
                        Text(
                          offer.deliveryPrefixLabel!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getMediumStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size9,
                            color: AppColors.textHint,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          offer.deliveryLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size9,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 0,
                top: 0,
                child: _RoundIcon(
                  icon: Icons.card_giftcard_rounded,
                  backgroundColor: offer.accentColor,
                  iconColor: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, size: 14, color: iconColor),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size10,
          color: AppColors.white,
        ),
      ),
    );
  }
}
