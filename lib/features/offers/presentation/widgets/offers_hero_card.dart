import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersHeroCard extends StatelessWidget {
  const OffersHeroCard({
    super.key,
    required this.hero,
  });

  final OffersHeroEntity hero;

  @override
  Widget build(BuildContext context) {
    return Container(height: 290,
      margin: const EdgeInsets.symmetric(horizontal: Spacing.base),
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF7E8), Color(0xFFF6FBF5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 12,
            child: _LeafDot(
              size: 18,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 10,
            child: _LeafDot(
              size: 22,
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _LeafDot(
              size: 28,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                         // vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          hero.badgeLabel,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size11,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        hero.discountLabel,
                        textAlign: TextAlign.end,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size36,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hero.title,
                       
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size19,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hero.subtitle,
                        textAlign: TextAlign.end,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hero.description,
                        textAlign: TextAlign.end,
                        style: getRegularStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: Spacing.base),
                      SizedBox(
                        width: 132,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Spacing.buttonRadius),
                            ),
                          ),
                          child: Text(hero.buttonLabel),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.base),
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: ClipOval(
                  child: Image.asset(
                    hero.imageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeafDot extends StatelessWidget {
  const _LeafDot({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
