import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';

class AddressCoverageNoticeSheet extends StatelessWidget {
  const AddressCoverageNoticeSheet({
    super.key,
    required this.notice,
    this.servingRestaurants = const [],
  });

  final CustomerAddressCoverageNoticeEntity notice;
  final List<ServingRestaurantEntity> servingRestaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final noticeText = notice.text(locale.localeName);

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
        bottom: MediaQuery.paddingOf(context).bottom + Spacing.lg,
      ),
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
                  Icons.storefront_outlined,
                  color: color.primary,
                  size: Spacing.iconMd,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  locale.address_coverage_notice_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size15,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Text(
            noticeText,
            textAlign: TextAlign.start,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          if (servingRestaurants.isNotEmpty) ...[
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
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: servingRestaurants.length,
                separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                itemBuilder: (context, index) {
                  final restaurant = servingRestaurants[index];
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
                        color: color.outlineVariant,
                        width: Spacing.hairline,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (logoUrl != null && logoUrl.isNotEmpty)
                          AppCachedNetworkImage(
                            imageUrl: logoUrl,
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                            semanticLabel: name,
                          )
                        else
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: color.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                name.isNotEmpty ? name.characters.first : '',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size14,
                                  color: color.primary,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: Spacing.xs),
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
                              Icon(
                                Icons.star_rounded,
                                color: color.primary,
                                size: 14,
                              ),
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
            ),
          ] else ...[
            Container(
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
            ),
          ],
          const SizedBox(height: Spacing.xl),
          AppButton(
            text: locale.address_coverage_notice_action,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
