import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_errors_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_header_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_list_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_restaurant_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_review_section.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

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

  DateTime get _fallbackDate =>
      DateUtils.dateOnly(widget.args?.date ?? DateTime.now());

  DateTime get _currentDate => _viewModel.state.selectedDate ?? _fallbackDate;

  @override
  void initState() {
    super.initState();
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
    );
  }

  @override
  void dispose() {
    if (!_isViewModelSupplied) {
      _viewModel.close();
    }
    super.dispose();
  }

  void _changeDay(int days) {
    final nextDate = DateUtils.dateOnly(_currentDate.add(Duration(days: days)));
    final locale = context.localization;
    _viewModel.doIntent(
      SelectFamilyCalendarDayEvent(
        day: CalendarDayEntity(
          dayNumber: nextDate.day,
          weekday: '',
          date: nextDate,
        ),
        localeName: locale.localeName,
      ),
    );
  }

  Future<void> _openDatePicker() async {
    final locale = context.localization;
    final validDates =
        _viewModel.state.days
            .map((day) => day.date)
            .whereType<DateTime>()
            .map(DateUtils.dateOnly)
            .toList()
          ..sort();
    if (validDates.isEmpty) return;

    final currentDate = _currentDate;
    final initialDate =
        validDates.any((date) => DateUtils.isSameDay(date, currentDate))
        ? currentDate
        : validDates.first;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: validDates.first,
      lastDate: validDates.last,
      selectableDayPredicate: (date) =>
          validDates.any((valid) => DateUtils.isSameDay(valid, date)),
      locale: Locale(locale.localeName),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    final cleanDate = DateUtils.dateOnly(pickedDate);
    if (DateUtils.isSameDay(cleanDate, currentDate)) {
      return;
    }

    _viewModel.doIntent(
      SelectFamilyCalendarDayEvent(
        day: CalendarDayEntity(
          dayNumber: cleanDate.day,
          weekday: '',
          date: cleanDate,
        ),
        localeName: locale.localeName,
      ),
    );
  }

  void _openRestaurants([String? slot]) {
    final subId =
        _viewModel.state.activeSubscriptionId ?? widget.args?.subscriptionId;
    if (subId == null || subId.isEmpty) return;

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
                BlocSelector<
                  FamilyCalendarViewModel,
                  FamilyCalendarState,
                  ({
                    List<FamilyMemberSummaryEntity> members,
                    int selectedMemberIndex,
                    String displayName,
                    DateTime selectedDate,
                  })
                >(
                  selector: (state) => (
                    members: state.members,
                    selectedMemberIndex: state.selectedMemberIndex,
                    displayName: state.displayName,
                    selectedDate: state.selectedDate ?? _fallbackDate,
                  ),
                  builder: (context, data) {
                    return FamilyDayMealsHeaderSection(
                      members: data.members,
                      selectedMemberIndex: data.selectedMemberIndex,
                      displayName: data.displayName,
                      fallbackMemberId: widget.args?.memberId,
                      fallbackSubscriptionId: widget.args?.subscriptionId,
                      selectedDate: data.selectedDate,
                      onMemberSelected: (index) {
                        _viewModel.doIntent(
                          SelectFamilyMemberEvent(
                            index: index,
                            localeName: locale.localeName,
                          ),
                        );
                      },
                      onPreviousDay: () => _changeDay(-1),
                      onNextDay: () => _changeDay(1),
                      onDatePressed: _openDatePicker,
                    );
                  },
                ),
                const SizedBox(height: Spacing.familyDayMemberTopGap),
                FamilyDayMealsRestaurantSection(
                  onOpenRestaurants: _openRestaurants,
                ),
                const SizedBox(height: Spacing.familyDayMemberTopGap),
                FamilyDayMealsErrorsSection(
                  onRetryCapabilities: () =>
                      _viewModel.doIntent(const RetryFamilyCapabilitiesEvent()),
                  onRetryCalendar: () => _viewModel.doIntent(
                    RetryFamilyCalendarEvent(localeName: locale.localeName),
                  ),
                  onRetryDay: () => _viewModel.doIntent(
                    RetryFamilyCalendarDayEvent(localeName: locale.localeName),
                  ),
                ),
                BlocSelector<
                  FamilyCalendarViewModel,
                  FamilyCalendarState,
                  ({
                    List<CalendarMealEntity> meals,
                    String restaurantName,
                    bool isEditable,
                    bool canEditMealsAndDays,
                    bool canUnitExchange,
                    bool isLoadingCalendar,
                    bool hasCalendarData,
                    Failure? calendarFailure,
                  })
                >(
                  selector: (state) => (
                    meals: state.selectedDay?.meals ?? const [],
                    restaurantName: state.selectedDay?.restaurant?.name ?? '',
                    isEditable: state.selectedDay?.isEditable == true,
                    canEditMealsAndDays: state.canEditMealsAndDays,
                    canUnitExchange: state.canUnitExchange,
                    isLoadingCalendar: state.isLoadingCalendar,
                    hasCalendarData: state.hasCalendarData,
                    calendarFailure: state.calendarFailure,
                  ),
                  builder: (context, data) {
                    return FamilyDayMealsListSection(
                      meals: data.meals,
                      restaurantName: data.restaurantName,
                      isEditable: data.isEditable,
                      canEditMealsAndDays: data.canEditMealsAndDays,
                      canUnitExchange: data.canUnitExchange,
                      isLoadingCalendar: data.isLoadingCalendar,
                      hasCalendarData: data.hasCalendarData,
                      calendarFailure: data.calendarFailure,
                      onRetryCalendar: () {
                        _viewModel.doIntent(
                          RetryFamilyCalendarEvent(
                            localeName: locale.localeName,
                          ),
                        );
                      },
                      onChooseMeals: () => _openRestaurants(null),
                      onEditMeal: _openMeals,
                    );
                  },
                ),
                const SizedBox(height: Spacing.familyDayReviewButtonTopGap),
                BlocSelector<
                  FamilyCalendarViewModel,
                  FamilyCalendarState,
                  ({
                    bool isEnabled,
                    bool hasMeals,
                    String? activeSubscriptionId,
                    String displayName,
                    DateTime selectedDate,
                    String? memberId,
                  })
                >(
                  selector: (state) {
                    final day = state.selectedDay;
                    final meals = day?.meals ?? const [];
                    final hasMeals = meals.isNotEmpty;
                    final isEnabled =
                        day?.isEditable == true &&
                        hasMeals &&
                        state.canConfirmMeals;
                    return (
                      isEnabled: isEnabled,
                      hasMeals: hasMeals,
                      activeSubscriptionId: state.activeSubscriptionId,
                      displayName: state.displayName,
                      selectedDate: state.selectedDate ?? _fallbackDate,
                      memberId:
                          state.currentMember?.memberId ??
                          widget.args?.memberId,
                    );
                  },
                  builder: (context, data) {
                    return FamilyDayMealsReviewSection(
                      isEnabled: data.isEnabled,
                      hasMeals: data.hasMeals,
                      onReviewPressed: () {
                        final activeSubId =
                            data.activeSubscriptionId ??
                            widget.args?.subscriptionId ??
                            '';
                        Navigator.of(context).pushNamed(
                          AppRoutes.familyReviewMemberMeals,
                          arguments: FamilyReviewMemberMealsArgs(
                            subscriptionId: activeSubId,
                            date: data.selectedDate,
                            memberName: data.displayName.isNotEmpty
                                ? data.displayName
                                : (widget.args?.memberName ?? ''),
                            memberId: data.memberId,
                            viewModel: _viewModel,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
