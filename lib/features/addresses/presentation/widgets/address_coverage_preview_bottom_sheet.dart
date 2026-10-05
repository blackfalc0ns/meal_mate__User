import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_restaurants_list.dart';

class AddressCoveragePreviewBottomSheet extends StatelessWidget {
  const AddressCoveragePreviewBottomSheet({
    super.key,
    required this.preview,
    required this.isSubmitting,
    required this.confirmButtonText,
    required this.onConfirm,
    required this.onChooseAnother,
    this.popOnConfirm = true,
    this.requireFamilyCoverage = false,
    this.isLoadingMore = false,
    this.hasMoreRestaurants = false,
    this.loadMoreFailure,
    this.onLoadMoreRestaurants,
  });

  final AddressCoveragePreviewEntity preview;
  final bool isSubmitting;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onChooseAnother;
  final bool popOnConfirm;
  final bool requireFamilyCoverage;
  final bool isLoadingMore;
  final bool hasMoreRestaurants;
  final Failure? loadMoreFailure;
  final VoidCallback? onLoadMoreRestaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isCovered =
        preview.canSetAsDefault &&
        (!requireFamilyCoverage ||
            (preview.resolvedRegionId != null &&
                preview.conflictMessage == null &&
                preview.servingRestaurants.isNotEmpty));
    final noticeText = preview.restaurantCoverageNotice?.text(
      locale.localeName,
    );
    final uncoveredName = preview.uncoveredRestaurantName(locale.localeName);
    final conflictText =
        preview.conflictMessage ??
        (uncoveredName != null && uncoveredName.isNotEmpty
            ? '${locale.address_coverage_uncovered_desc} ($uncoveredName)'
            : locale.address_coverage_uncovered_desc);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Spacing.bottomSheetRadius),
            ),
          ),
          padding: const EdgeInsets.only(
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
                  AddressCoverageRestaurantsList(
                    restaurants: preview.servingRestaurants,
                    isLoadingMore: isLoadingMore,
                    hasMoreRestaurants: hasMoreRestaurants,
                    loadMoreFailure: loadMoreFailure,
                    onLoadMoreRestaurants: onLoadMoreRestaurants,
                  ),
                ] else if (isCovered) ...[
                  _buildNoRestaurantsNotice(context),
                ],
                const SizedBox(height: Spacing.xl),
                AppButton.filled(
                  text: confirmButtonText,
                  isLoading: false,
                  onPressed: isCovered && !isSubmitting
                      ? () {
                          if (popOnConfirm) Navigator.of(context).pop();
                          onConfirm();
                        }
                      : null,
                  height: Spacing.buttonSmallHeight,
                  borderRadius: Spacing.radiusPill,
                  color: isCovered ? color.primary : color.outlineVariant,
                  textColor: isCovered
                      ? color.onPrimary
                      : color.onSurfaceVariant,
                  fontSize: FontSize.size13,
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
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusPill,
                          ),
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
        ),
        if (isSubmitting)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: color.scrim.withValues(alpha: 0.32),
                child: const Center(child: CustomProgressIndicator()),
              ),
            ),
          ),
      ],
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
