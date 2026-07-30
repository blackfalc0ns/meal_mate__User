import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class OffersHeroCard extends StatelessWidget {
  const OffersHeroCard({super.key, required this.hero});

  final OffersHeroEntity hero;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AspectRatio(
      aspectRatio: Spacing.offersHeroAspectRatio,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Spacing.offersHeroRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PositionedDirectional(
              start: -Spacing.sm,
              top: -Spacing.md,
              bottom: -Spacing.sm,
              width: Spacing.offersHeroImageWidth,
              child: Image.asset(hero.imageAsset, fit: BoxFit.contain),
            ),
            PositionedDirectional(
              start: Spacing.base,
              top: Spacing.xs,
              child: Container(
                width: Spacing.offersHeroBadgeSize,
                height: Spacing.offersHeroBadgeSize,
                decoration: BoxDecoration(
                  color: color.secondary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hero.discountLabel,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size20,
                        color: color.onSecondary,
                      ),
                    ),
                    Text(
                      hero.badgeLabel,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size13,
                        color: color.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              end: Spacing.xxl,
              top: Spacing.base,
              bottom: Spacing.base,
              width: Spacing.offersHeroCopyWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppLogo(size: Spacing.xl),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    hero.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size26,
                      color: color.primary,
                    ),
                  ),
                  Text(
                    hero.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size20,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    hero.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: Spacing.offersHeroButtonWidth,
                    height: Spacing.offersHeroButtonHeight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.secondary,
                        foregroundColor: color.onSecondary,
                        padding: EdgeInsets.zero,
                        shape: const StadiumBorder(),
                        elevation: Spacing.cardElevation,
                      ),
                      child: Text(
                        hero.buttonLabel,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size14,
                          color: color.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              label: locale.offers_title,
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
