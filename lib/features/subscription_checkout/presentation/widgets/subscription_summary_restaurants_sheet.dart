import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

class SubscriptionSummaryRestaurantsSheet extends StatelessWidget {
  const SubscriptionSummaryRestaurantsSheet({
    super.key,
    required this.restaurants,
  });

  final List<SubscriptionSummaryRestaurantEntity> restaurants;

  static Future<void> show({
    required BuildContext context,
    required List<SubscriptionSummaryRestaurantEntity> restaurants,
  }) {
    final color = context.colorScheme;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: color.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (_) => SubscriptionSummaryRestaurantsSheet(
        restaurants: restaurants,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.75;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.base,
            vertical: Spacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: Spacing.xxxl,
                  height: Spacing.xs,
                  decoration: BoxDecoration(
                    color: color.outlineVariant,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.base),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.subscription_summary_all_restaurants,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size18,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: color.tertiaryContainer,
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusPill,
                          ),
                        ),
                        child: Text(
                          '${restaurants.length}',
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: color.onSurfaceVariant,
                      size: Spacing.iconMd,
                    ),
                    visualDensity: VisualDensity.compact,
                    splashRadius: Spacing.xl,
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Divider(
                height: Spacing.border,
                thickness: Spacing.border,
                color: color.outlineVariant,
              ),
              const SizedBox(height: Spacing.sm),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: restaurants.length,
                  separatorBuilder: (_, _) => Divider(
                    height: Spacing.border,
                    thickness: Spacing.border,
                    color: color.outlineVariant,
                  ),
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Spacing.sm,
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: Spacing.avatarSm,
                              height: Spacing.avatarSm,
                              child: restaurant.logoUrl == null
                                  ? Icon(
                                      Icons.restaurant_rounded,
                                      color: color.primary,
                                      size: Spacing.iconMd,
                                    )
                                  : AppCachedNetworkImage(
                                      imageUrl: restaurant.logoUrl!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: Text(
                              restaurant.name(locale.localeName),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurface,
                              ),
                            ),
                          ),
                          if (restaurant.tier.isNotEmpty) ...[
                            const SizedBox(width: Spacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                                vertical: Spacing.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: color.tertiaryContainer,
                                borderRadius: BorderRadius.circular(
                                  Spacing.radiusXs,
                                ),
                              ),
                              child: Text(
                                restaurant.tier,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size11,
                                  color: color.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
