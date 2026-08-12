import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class LocationConfirmationCard extends StatelessWidget {
  const LocationConfirmationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.addressesChooseLocationCardWidth,
      padding: const EdgeInsets.all(Spacing.addressesChooseLocationCardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.addressesChooseLocationCardRadius,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: Spacing.addressesChooseLocationHeaderGap),
              Container(
                width: Spacing.addressesChooseLocationHeroIconSize,
                height: Spacing.addressesChooseLocationHeroIconSize,
                decoration: BoxDecoration(
                  color: color.secondaryContainer,
                  borderRadius: BorderRadius.circular(
                    Spacing.addressesChooseLocationCardRadius,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.addressesIconHome,
                    width: Spacing.addressesChooseLocationHeroGlyphSize,
                    height: Spacing.addressesChooseLocationHeroGlyphSize,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.addressesChooseLocationHeaderGap),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.addresses_choose_location_title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: Spacing.addressesChooseLocationTitleSize,
                        color: color.primary,
                      ),
                    ),
                    Text(
                      locale.addresses_choose_location_subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: Spacing.addressesChooseLocationSubtitleSize,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.addressesChooseLocationHeaderGap),
          Divider(
            color: color.outlineVariant,
            height: Spacing.addressesChooseLocationLineHeight,
            thickness: Spacing.addressesChooseLocationLineHeight,
          ),
          const SizedBox(height: Spacing.addressesChooseLocationHeaderGap),
          SizedBox(
            height: Spacing.addressesChooseLocationButtonHeight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color.primary,
                foregroundColor: color.onPrimary,
                elevation: Spacing.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Spacing.addressesChooseLocationButtonRadius,
                  ),
                ),
              ),
              child: Text(
                locale.addresses_confirm_location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: Spacing.addressesChooseLocationButtonTextSize,
                  color: color.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
