import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_daily_macros_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_day_meals_loading_skeleton.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_frozen_day_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_summary_card.dart';

class CalendarDayContent extends StatelessWidget {
  const CalendarDayContent({
    super.key,
    required this.selectedDay,
    this.deliveryItem,
    this.deliveryItems = const [],
    required this.showBottomSpace,
    required this.onSelectRestaurant,
    required this.onChangeMeal,
    required this.onMealTap,
    this.onTrackDelivery,
    this.onConfirmSelections,
    this.isConfirming = false,
    this.canConfirm = false,
    this.isLoading = false,
  });
  final CalendarDayEntity? selectedDay;
  final CustomerDeliveryItemEntity? deliveryItem;
  final List<CustomerDeliveryItemEntity> deliveryItems;
  final bool showBottomSpace;
  final VoidCallback onSelectRestaurant;
  final VoidCallback onChangeMeal;
  final void Function(CalendarMealEntity, CalendarRestaurantEntity?) onMealTap;
  final void Function(CustomerDeliveryItemEntity)? onTrackDelivery;
  final VoidCallback? onConfirmSelections;
  final bool isConfirming;
  final bool canConfirm;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final slideBegin = isRtl ? 0.06 : -0.06;
    final restaurant = selectedDay?.restaurant;
    final meals = selectedDay?.meals ?? const [];
    final readOnly = selectedDay?.isEditable != true;
    final hasMeals = meals.isNotEmpty;
    final isAwaiting = selectedDay?.isAwaitingRestaurantConfirmation == true;
    final isConfirmed = selectedDay?.isConfirmed == true;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsetsDirectional.only(
        start: Spacing.screenH,
        end: Spacing.screenH,
        top: Spacing.base,
        bottom: showBottomSpace
            ? Spacing.bottomNavHeight + Spacing.xxxl + Spacing.md
            : Spacing.xl,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[...previousChildren, ?currentChild],
        ),
        child: isLoading
            ? const CalendarDayMealsLoadingSkeleton()
            : Column(
                key: ValueKey(
                  '${selectedDay?.date?.toIso8601String()}_${hasMeals}_${selectedDay?.isFrozen}',
                ),
                children: [
                  for (final item in (deliveryItems.isNotEmpty
                      ? deliveryItems
                      : (deliveryItem != null ? [deliveryItem!] : const <CustomerDeliveryItemEntity>[]))) ...[
                    if (item.shouldShowDeliveryCard) ...[
                      CalendarDeliveryCard(
                        key: ValueKey(
                          'delivery_${item.orderCode ?? item.subscriptionDayId ?? selectedDay?.date?.toIso8601String()}',
                        ),
                        deliveryItem: item,
                        onTrackOrDetails: () => onTrackDelivery?.call(item),
                      )
                          .animate()
                          .fadeIn(duration: 250.ms)
                          .slideX(
                            begin: slideBegin,
                            end: 0,
                            duration: 250.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: Spacing.md),
                    ],
                  ],
                  if (selectedDay?.isFrozen == true)
                    const CalendarFrozenDayState()
                  else if (!hasMeals)
                    CalendarEmptyMealsState(
                      key: ValueKey(
                        'empty_meals_${selectedDay?.date?.toIso8601String()}',
                      ),
                      // ignore: unnecessary_lambdas
                      onAddMeals: readOnly ? null : () => onSelectRestaurant(),
                    )
                  else ...[
                    Row(
                          children: [
                            if (isAwaiting)
                              SizedBox(
                                width: Spacing.iconMd,
                                // height: Spacing.iconMd,
                                child: Transform.scale(
                                  scale: 2.3,
                                  child: Lottie.asset(
                                    key: const ValueKey(
                                      'awaiting_hourglass_lottie',
                                    ),
                                    repeat: true,
                                    Assets.hourglassAnimation,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            else
                              Icon(
                                Icons.check_circle_rounded,
                                color: color.primary,
                                size: Spacing.iconMd,
                              ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              isAwaiting
                                  ? locale.calendar_status_awaiting_restaurant
                                  : locale.calendar_confirm_selection_header,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size13,
                                color: color.onSurface,
                              ),
                            ),
                          ],
                        )
                        .animate(
                          key: ValueKey(
                            'header_${selectedDay?.date?.toIso8601String()}_${isAwaiting}_$isConfirmed',
                          ),
                        )
                        .fadeIn(duration: 250.ms)
                        .slideX(
                          begin: slideBegin,
                          end: 0,
                          duration: 250.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: Spacing.md),
                    if (restaurant != null) ...[
                      CalendarRestaurantSummaryCard(
                            key: ValueKey(
                              '${selectedDay?.date?.toIso8601String() ?? ''}-${restaurant.id}-${meals.length}',
                            ),
                            restaurant: restaurant,
                            day: selectedDay,
                            onMorePressed: readOnly ? null : onSelectRestaurant,
                          )
                          .animate()
                          .fadeIn(duration: 200.ms)
                          .slideX(
                            begin: slideBegin,
                            end: 0,
                            duration: 220.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: Spacing.sm),
                      CalendarDailyMacrosCard(
                            totals:
                                selectedDay?.nutritionTotals ??
                                const CalendarNutritionTotalsEntity(),
                          )
                          .animate()
                          .fadeIn(duration: 200.ms)
                          .slideX(
                            begin: slideBegin,
                            end: 0,
                            duration: 220.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: Spacing.sm),
                    ],
                    for (final meal in meals) ...[
                      CalendarMealCard(
                            meal: meal,
                            readOnly: readOnly,
                            onTap: () => onMealTap(meal, restaurant),
                            onChangeMeal: onChangeMeal,
                          )
                          .animate()
                          .fadeIn(duration: 200.ms)
                          .slideX(
                            begin: slideBegin,
                            end: 0,
                            duration: 220.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: Spacing.md),
                    ],
                  ],
                ],
              ),
      ),
    );
  }
}
