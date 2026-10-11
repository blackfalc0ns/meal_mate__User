import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurant_logo.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';

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

    SubscriptionPlanViewModel? viewModel;
    try {
      viewModel = context.read<SubscriptionPlanViewModel>();
    } catch (_) {
      viewModel = null;
    }

    if (viewModel != null) {
      final isStillPresent = viewModel.state.browseRestaurants.any(
        (r) => r.restaurantId == widget.restaurant.restaurantId,
      );
      final isReady =
          viewModel.state.browseAvailability == null ||
          viewModel.state.browseAvailability!.isAvailable;

      if (!isStillPresent || !isReady) {
        final browsedTierIndex = viewModel.state.browsedTierIndex;
        if (browsedTierIndex != null) {
          viewModel.doIntent(
            BrowseSubscriptionTierRestaurantsEvent(
              programId: widget.restaurant.programId,
              bundleId: widget.restaurant.bundleId,
              tierIndex: browsedTierIndex,
              startDate: viewModel.state.selectedStartDate,
            ),
          );
        }
        return;
      }
    }

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
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xs,
            vertical: Spacing.xs,
          ),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.monthlyRestaurantCardRadius,
            ),
            border: Border.all(
              color: color.outlineVariant,
              width: Spacing.monthlyRestaurantCardBorderWidth,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardHeight = constraints.maxHeight;
              final logoSize = (cardHeight * 0.32).clamp(30.0, 48.0);
              final isCompact = cardHeight < 128;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubscriptionRestaurantLogo(
                    restaurant: widget.restaurant,
                    size: logoSize,
                  ),
                  SizedBox(
                    height: isCompact ? 20 : 24,
                    child: Center(
                      child: Text(
                        widget.restaurant.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: isCompact
                              ? FontSize.size9
                              : FontSize.size10,
                          color: color.onSurface,
                        ).copyWith(height: 1.15),
                      ),
                    ),
                  ),
                  if (tierOrSubtitle.isNotEmpty)
                    Text(
                      tierOrSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: isCompact ? FontSize.size10 : FontSize.size12,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.restaurant.rating.isNotEmpty) ...[
                        Icon(
                          Icons.star_rounded,
                          size: 11.0,
                          color: color.primary,
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          widget.restaurant.rating,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: isCompact
                        ? 16.0
                        : Spacing.monthlyRestaurantCardMetaHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.ramen_dining_rounded,
                          size: 11.0,
                          color: color.primary,
                        ),
                        const SizedBox(width: 3.0),
                        Flexible(
                          child: Text(
                            '${widget.restaurant.bundleMeals} ${locale.subscription_details_meals_in_plan}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size8,
                              color: color.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
