import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurant_logo.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_args.dart';

class SubscriptionRestaurantGridCard extends StatefulWidget {
  const SubscriptionRestaurantGridCard({super.key, required this.restaurant});

  final MonthlyRestaurantPlanEntity restaurant;

  @override
  State<SubscriptionRestaurantGridCard> createState() =>
      _SubscriptionRestaurantGridCardState();
}

class _SubscriptionRestaurantGridCardState
    extends State<SubscriptionRestaurantGridCard> {
  static bool _isPushingRestaurantDetails = false;

  bool _isOpening = false;

  Future<void> _openRestaurantDetails() async {
    if (_isOpening || _isPushingRestaurantDetails) return;

    _isPushingRestaurantDetails = true;
    setState(() => _isOpening = true);
    try {
      await context.pushNamed(
        AppRoutes.restaurantDetails,
        arguments: SubscriptionRestaurantDetailsArgs(
          programId: widget.restaurant.programId,
          bundleId: widget.restaurant.bundleId,
          restaurantId: widget.restaurant.restaurantId,
          restaurantName: widget.restaurant.name,
          restaurantLogoUrl: widget.restaurant.logoUrl,
          restaurantInitials: widget.restaurant.initials,
          restaurantRating: widget.restaurant.rating,
        ),
      );
    } finally {
      _isPushingRestaurantDetails = false;
      if (mounted) {
        setState(() => _isOpening = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final tierOrSubtitle = widget.restaurant.tierName.isNotEmpty
        ? widget.restaurant.tierName
        : widget.restaurant.subtitle;

    return Material(
      color: color.surface.withValues(alpha: 0),
      borderRadius: BorderRadius.circular(Spacing.monthlyRestaurantCardRadius),
      child: InkWell(
        onTap: _isOpening ? null : _openRestaurantDetails,
        borderRadius: BorderRadius.circular(
          Spacing.monthlyRestaurantCardRadius,
        ),
        child: Ink(
          padding: const EdgeInsetsDirectional.only(
            top: Spacing.md,
            bottom: Spacing.sm,
            start: Spacing.md,
            end: Spacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Spacing.monthlyRestaurantCardRadius,
            ),
            border: Border.all(
              color: color.outlineVariant,
              width: Spacing.monthlyRestaurantCardBorderWidth,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SubscriptionRestaurantLogo(
                restaurant: widget.restaurant,
                size: Spacing.iconXl,
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                widget.restaurant.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ).copyWith(height: 1.25),
              ),
              if (tierOrSubtitle.isNotEmpty) ...[
                const SizedBox(height: Spacing.sm),
                Text(
                  tierOrSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
              const Spacer(),
              Container(
                width: double.infinity,
                height: Spacing.monthlyRestaurantCardMetaHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Text(
                  '${widget.restaurant.bundleMeals} ${locale.subscription_details_meal_suffix}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
