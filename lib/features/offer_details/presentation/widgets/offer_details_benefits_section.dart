import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_data.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_benefit_card.dart';

class OfferDetailsBenefitsSection extends StatelessWidget {
  const OfferDetailsBenefitsSection({super.key, required this.details});

  final OfferDetailsData details;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            details.benefitsTitle,
            semanticsLabel: locale.app_brand_name,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: details.benefits
              .map(
                (benefit) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                    child: OfferDetailsBenefitCard(benefit: benefit),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
