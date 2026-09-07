import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';

class AddressCoveragePreviewBottomSheet extends StatelessWidget {
  const AddressCoveragePreviewBottomSheet({
    super.key,
    required this.preview,
    required this.isSubmitting,
    required this.confirmButtonText,
    required this.onConfirm,
    required this.onChooseAnother,
  });

  final AddressCoveragePreviewEntity preview;
  final bool isSubmitting;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onChooseAnother;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isCovered = preview.canSetAsDefault;
    final noticeText = preview.restaurantCoverageNotice?.text(
      locale.localeName,
    );
    final uncoveredName = preview.uncoveredRestaurantName(locale.localeName);
    final conflictText =
        preview.conflictMessage ??
        (uncoveredName != null && uncoveredName.isNotEmpty
            ? '${locale.address_coverage_uncovered_desc} ($uncoveredName)'
            : locale.address_coverage_uncovered_desc);

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      padding: EdgeInsets.only(
        left: Spacing.xl,
        right: Spacing.xl,
        top: Spacing.md,
        //   bottom: MediaQuery.paddingOf(context).bottom + Spacing.lg,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: Spacing.xs,
                decoration: BoxDecoration(
                  color: color.outlineVariant,
                  borderRadius: BorderRadius.circular(Spacing.xs),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            if (isCovered) ...[
              _buildCoveredHeader(context, noticeText),
            ] else ...[
              _buildUncoveredBanner(context, conflictText),
            ],
            const SizedBox(height: Spacing.lg),
            if (preview.servingRestaurants.isNotEmpty) ...[
              Text(
                locale.address_serving_restaurants_title,
                textAlign: TextAlign.start,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              _buildServingRestaurantsList(context, preview.servingRestaurants),
            ] else if (isCovered) ...[
              _buildNoRestaurantsNotice(context),
            ],
            const SizedBox(height: Spacing.xl),
            AppButton.filled(
              text: confirmButtonText,
              isLoading: isSubmitting,
              onPressed: isCovered && !isSubmitting
                  ? () {
                      Navigator.of(context).pop();
                      onConfirm();
                    }
                  : null,
              height: Spacing.buttonHeight,
              borderRadius: Spacing.radiusPill,
              color: isCovered ? color.primary : color.outlineVariant,
              textColor: isCovered ? color.onPrimary : color.onSurfaceVariant,
              fontSize: FontSize.size15,
            ),
            if (!isCovered) ...[
              const SizedBox(height: Spacing.md),
              SizedBox(
                height: Spacing.buttonHeight,
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : onChooseAnother,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    ),
                  ),
                  child: Text(
                    locale.address_coverage_choose_another,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCoveredHeader(BuildContext context, String? noticeText) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: color.primary,
                size: Spacing.iconMd,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                locale.address_coverage_covered_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size15,
                  color: color.onSurface,
                ),
              ),
            ),
          ],
        ),
        if (noticeText != null && noticeText.isNotEmpty) ...[
          const SizedBox(height: Spacing.sm),
          Text(
            noticeText,
            textAlign: TextAlign.start,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUncoveredBanner(BuildContext context, String conflictText) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.errorContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(
          color: color.error.withValues(alpha: 0.3),
          width: Spacing.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: color.error,
                size: Spacing.iconMd,
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  locale.address_coverage_uncovered_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            conflictText,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServingRestaurantsList(
    BuildContext context,
    List<ServingRestaurantEntity> restaurants,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: restaurants.length,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          final name = restaurant.name(locale.localeName);
          final logoUrl = restaurant.logoUrl;
          final rating = restaurant.rating;

          return Container(
            width: 104,
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
              border: Border.all(
                color: AppColors.addressesInputLabel,
                //color.outlineVariant,
                width: Spacing.hairline,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppCachedNetworkImage(
                  imageUrl: logoUrl,
                  width: 38,
                  height: 38,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: Spacing.xs),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ),
                ),
                if (rating != null && rating > 0) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded, color: color.primary, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        rating.toStringAsFixed(1),
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoRestaurantsNotice(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.errorContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(
          color: color.error.withValues(alpha: 0.3),
          width: Spacing.hairline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color.error,
            size: Spacing.iconMd,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              locale.address_no_serving_restaurants,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
