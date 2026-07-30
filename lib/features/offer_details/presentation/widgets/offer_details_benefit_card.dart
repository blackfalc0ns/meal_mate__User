import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_icon.dart';

class OfferDetailsBenefitCard extends StatelessWidget {
  const OfferDetailsBenefitCard({super.key, required this.benefit});

  final OfferDetailsBenefitData benefit;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.offerDetailsBenefitCardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(
          Spacing.offerDetailsBenefitCardRadius,
        ),
      ),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: benefit.icon == OfferDetailsIconType.target
                  ? color.primaryContainer.withValues(alpha: 0.35)
                  : color.secondaryContainer.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: Spacing.offerDetailsBenefitIconSize,
              child: Center(
                child: OfferDetailsIcon(
                  type: benefit.icon,
                  size: Spacing.iconLg,
                  tint: benefit.icon == OfferDetailsIconType.target
                      ? color.tertiary
                      : color.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            benefit.title,
            semanticsLabel: locale.app_brand_name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Expanded(
            child: Text(
              benefit.description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
