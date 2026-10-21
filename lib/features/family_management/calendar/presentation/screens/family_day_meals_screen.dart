import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_errors_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_header_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_list_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_restaurant_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_review_section.dart';

class FamilyDayMealsScreen extends StatefulWidget {
  const FamilyDayMealsScreen({super.key, this.args, this.viewModel});

  final FamilyDayMealsArgs? args;
  final FamilyCalendarViewModel? viewModel;

  @override
  State<FamilyDayMealsScreen> createState() => _FamilyDayMealsScreenState();
}

class _FamilyDayMealsScreenState extends State<FamilyDayMealsScreen> {
  late final FamilyCalendarViewModel _viewModel;
  late final bool _isViewModelSupplied;
  bool _initialized = false;

  late final DateTime _fallbackDate;

  DateTime get _currentDate => _viewModel.state.selectedDate ?? _fallbackDate;

  @override
  void initState() {
    super.initState();
    _fallbackDate = DateUtils.dateOnly(widget.args?.date ?? DateTime.now());
    final suppliedViewModel = widget.viewModel ?? widget.args?.viewModel;
    _isViewModelSupplied = suppliedViewModel != null;
    _viewModel = suppliedViewModel ?? getIt<FamilyCalendarViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final initialDate = _currentDate;
    unawaited(
      _viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: FamilyMemberCalendarArgs(
            memberId: widget.args?.memberId,
            displayName: widget.args?.memberName,
            subscriptionId: widget.args?.subscriptionId,
            members: widget.args?.members ?? const [],
            date: initialDate,
          ),
          initialDate: initialDate,
          localeName: context.localization.localeName,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (!_isViewModelSupplied) {
      unawaited(_viewModel.close());
    }
    super.dispose();
  }

  void _changeDay(int days) {
    final nextDate = DateUtils.dateOnly(_currentDate.add(Duration(days: days)));
    final locale = context.localization;
    unawaited(
      _viewModel.doIntent(
        SelectFamilyCalendarDayEvent(
          day: CalendarDayEntity(
            dayNumber: nextDate.day,
            weekday: '',
            date: nextDate,
          ),
          localeName: locale.localeName,
        ),
      ),
    );
  }

  void _openRestaurants([String? slot]) {
    final subId =
        _viewModel.state.activeSubscriptionId ?? widget.args?.subscriptionId;
    if (subId == null || subId.isEmpty) return;

    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.familyRestaurants,
        arguments: FamilyRestaurantsArgs(
          subscriptionId: subId,
          date: _currentDate,
          memberName: _viewModel.state.displayName.isNotEmpty
              ? _viewModel.state.displayName
              : (widget.args?.memberName ?? ''),
          memberId:
              _viewModel.state.currentMember?.memberId ?? widget.args?.memberId,
          members: _viewModel.state.members.isNotEmpty
              ? _viewModel.state.members
              : (widget.args?.members ?? const []),
          slot: slot ?? '',
          viewModel: _viewModel,
        ),
      ),
    );
  }

  void _openMeals(String slot) {
    final state = _viewModel.state;
    final restaurant = state.selectedDay?.restaurant;
    final subId = state.activeSubscriptionId ?? widget.args?.subscriptionId;
    if (restaurant == null ||
        restaurant.id.isEmpty ||
        subId == null ||
        subId.isEmpty) {
      return;
    }

    final restaurantOption = CalendarRestaurantOptionEntity(
      id: restaurant.id,
      logoUrl: restaurant.logoUrl,
      tierLogoUrl: restaurant.tierLogoUrl,
      maxUsageCount: restaurant.maxUsageCount,
      name: restaurant.name,
      description: restaurant.category,
      mealCount: state.selectedDay?.meals.length ?? 0,
      rating: restaurant.rating,
      ratingCount: restaurant.ratingCount,
      deliveryWindow: restaurant.deliveryWindow,
      tierName: restaurant.deliveryDuration,
      logoType: CalendarRestaurantLogoType.healthyBowl,
    );

    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.familyMealSelection,
        arguments: FamilyMealSelectionArgs(
          subscriptionId: subId,
          date: _currentDate,
          memberName: state.displayName,
          slot: slot,
          restaurant: restaurantOption,
          restaurantName: restaurant.name,
          viewModel: _viewModel,
        ),
      ),
    );
  }

  void _selectMember(int index) => unawaited(
    _viewModel.doIntent(
      SelectFamilyMemberEvent(
        index: index,
        localeName: context.localization.localeName,
      ),
    ),
  );
  void _previousDay() => _changeDay(-1);
  void _nextDay() => _changeDay(1);
  void _retryCalendar() => unawaited(
    _viewModel.doIntent(
      RetryFamilyCalendarEvent(localeName: context.localization.localeName),
    ),
  );

  void _openReview() {
    final state = _viewModel.state;
    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.familyReviewMemberMeals,
        arguments: FamilyReviewMemberMealsArgs(
          subscriptionId:
              state.activeSubscriptionId ?? widget.args?.subscriptionId ?? '',
          date: state.selectedDate ?? _fallbackDate,
          memberName: state.displayName.isNotEmpty
              ? state.displayName
              : (widget.args?.memberName ?? ''),
          memberId: state.currentMember?.memberId ?? widget.args?.memberId,
          viewModel: _viewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilyCalendarViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          titleWidget: Text(
            locale.family_day_screen_title,
            locale: Locale(locale.localeName),
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size18,
              color: color.onSurface,
            ),
          ),
          onBackPressed: () => Navigator.maybePop(context),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsetsDirectional.only(
              start: Spacing.familyDayHorizontalPadding,
              end: Spacing.familyDayHorizontalPadding,
              bottom: Spacing.xl,
            ),
            child: Column(
              children: [
                FamilyDayMealsHeaderSection(
                  fallbackMemberId: widget.args?.memberId,
                  fallbackSubscriptionId: widget.args?.subscriptionId,
                  fallbackDate: _fallbackDate,
                  onMemberSelected: _selectMember,
                  onPreviousDay: _previousDay,
                  onNextDay: _nextDay,
                ),
                const SizedBox(height: Spacing.familyDayMemberTopGap),
                FamilyDayMealsRestaurantSection(
                  onOpenRestaurants: _openRestaurants,
                ),
                const SizedBox(height: Spacing.familyDayMemberTopGap),
                FamilyDayMealsErrorsSection(
                  onRetryCalendar: () => unawaited(
                    _viewModel.doIntent(
                      RetryFamilyCalendarEvent(localeName: locale.localeName),
                    ),
                  ),
                  onRetryDay: () => unawaited(
                    _viewModel.doIntent(
                      RetryFamilyCalendarDayEvent(
                        localeName: locale.localeName,
                      ),
                    ),
                  ),
                ),
                FamilyDayMealsListSection(
                  onRetryCalendar: _retryCalendar,
                  onChooseMeals: _openRestaurants,
                  onEditMeal: _openMeals,
                ),
                const SizedBox(height: Spacing.familyDayReviewButtonTopGap),
                FamilyDayMealsReviewSection(onReviewPressed: _openReview),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
