import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_view_model.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/models/family_member_restaurants_ui_model.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_member_restaurants.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_restaurant_repetition_banner.dart';

class FamilyMemberRestaurantsCard extends StatelessWidget {
  const FamilyMemberRestaurantsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      FamilyCheckoutViewModel,
      FamilyCheckoutState,
      FamilyMemberRestaurantsUiModel
    >(
      selector: (state) {
        final activeMemberId = state.activeMemberId;
        final schedule = state.scheduleForMember(activeMemberId);
        final matchingMember = state.members
            .where((m) => m.memberId == activeMemberId)
            .firstOrNull;
        final summaryMember = state.summary?.members
            .where((m) => m.memberId == activeMemberId)
            .firstOrNull;

        final memberName =
            summaryMember?.displayName ?? matchingMember?.displayName ?? '';

        final isSubscribed = matchingMember?.subscribeNow ?? true;

        final durationDays =
            (schedule?.deliveryDaysCount != null &&
                schedule!.deliveryDaysCount > 0)
            ? schedule.deliveryDaysCount
            : (matchingMember?.durationDays ?? 20);

        final restaurants = schedule?.restaurants ?? const [];
        final repetition = schedule?.restaurantRepetition;
        final repetitionLimit = repetition?.limit ?? 0;
        final restaurantCount =
            repetition?.restaurantCount ?? restaurants.length;

        return FamilyMemberRestaurantsUiModel(
          memberId: activeMemberId,
          memberName: memberName,
          restaurants: restaurants,
          repetitionLimit: repetitionLimit,
          restaurantCount: restaurantCount,
          durationDays: durationDays,
          isSubscribed: isSubscribed,
        );
      },
      builder: (context, data) {
        final color = context.colorScheme;
        final locale = context.localization;

        final effectiveTotal = data.restaurantCount > 0
            ? data.restaurantCount
            : data.restaurants.length;

        return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: color.surface,
                border: Border.all(
                  color: data.isSubscribed
                      ? color.outlineVariant
                      : color.outlineVariant.withValues(alpha: 0.5),
                  width: Spacing.border,
                ),
                borderRadius: BorderRadius.circular(
                  Spacing.familySetupMemberCardRadius,
                ),
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: data.isSubscribed ? 1.0 : 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: Spacing.avatarSm,
                          height: Spacing.avatarSm,
                          decoration: BoxDecoration(
                            color: color.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusSm,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.storefront_rounded,
                            color: color.primary,
                            size: Spacing.iconSm,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            locale.subscription_participating_restaurants,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                        if (effectiveTotal > 0) ...[
                          const SizedBox(width: Spacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                              vertical: Spacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: color.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                Spacing.radiusPill,
                              ),
                            ),
                            child: Text(
                              locale.family_member_restaurants_count(
                                effectiveTotal,
                              ),
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: color.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: Spacing.base),
                    FamilyMemberRestaurants(restaurants: data.restaurants),
                    if (data.repetitionLimit > 0) ...[
                      const SizedBox(height: Spacing.md),
                      FamilyRestaurantRepetitionBanner(
                        limit: data.repetitionLimit,
                        durationDays: data.durationDays,
                      ),
                    ],
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 350.ms)
            .slideY(
              begin: 0.05,
              end: 0,
              duration: 350.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }
}
