import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class RestaurantOfferCard extends StatelessWidget {
  const RestaurantOfferCard({super.key, required this.offer});

  final OfferDealEntity offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 154,
      decoration: BoxDecoration(border: Border.all(color:AppColors.border),
        borderRadius: BorderRadius.circular(22,),
       // color: AppColors.background,
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.shadow.withValues(alpha: 0.06),
        //     blurRadius: 12,
        //     offset: const Offset(0, 5),
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 92,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    offer.accentColor,
                    offer.accentColor.withValues(alpha: 0.72),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        size: 12,
                        color: offer.accentColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      offer.logoAsset,
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _Badge(
                      label: offer.discountLabel,
                      textColor: offer.accentColor,
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 13,
                        color: offer.accentColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        offer.title,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 6),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _MetaItem(
                        icon: Icons.place_outlined,
                        text: offer.deliveryLabel,
                        textColor: AppColors.textSecondary,
                      ),
                      _MetaItem(
                        icon: Icons.star_rounded,
                        text: offer.reviewLabel,
                        iconColor: AppColors.starFilled,
                        textColor: AppColors.textSecondary,
                      ),
                      Text(
                        'توصيل مجاني',
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size9,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: offer.accentColor,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        offer.buttonLabel,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size11,
                          color: AppColors.white,
                        ),
                      ),
                    ),
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

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });

  final String label;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 13,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: FittedBox(
        child: Text(
          textAlign: TextAlign.center,
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size15,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.text,
    required this.textColor,
    this.iconColor = AppColors.textHint,
  });

  final IconData icon;
  final String text;
  final Color textColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: iconColor),
        const SizedBox(width: 3),
        Text(
          text,
          style: getMediumStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size9,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
