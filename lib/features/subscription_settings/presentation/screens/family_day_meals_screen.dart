import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_meal_selection_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_restaurants_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_review_member_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_current_restaurant_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_header.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_meal_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_meals_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_selected_status.dart';

class FamilyDayMealsScreen extends StatefulWidget {
  const FamilyDayMealsScreen({super.key, this.args, this.viewModel});

  final FamilyDayMealsArgs? args;
  final FamilyCalendarViewModel? viewModel;

  @override
  State<FamilyDayMealsScreen> createState() => _FamilyDayMealsScreenState();
}

class _FamilyDayMealsScreenState extends State<FamilyDayMealsScreen> {
  late final FamilyCalendarViewModel _viewModel;
  late DateTime _selectedDate;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _viewModel =
        widget.viewModel ??
        (getIt.isRegistered<FamilyCalendarViewModel>()
            ? getIt<FamilyCalendarViewModel>()
            : FamilyCalendarViewModel());
    _selectedDate = DateUtils.dateOnly(widget.args?.date ?? DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _viewModel.doIntent(
      InitFamilyCalendarEvent(
        args: FamilyMemberCalendarArgs(
          memberId: widget.args?.memberId,
          displayName: widget.args?.memberName,
          subscriptionId: widget.args?.subscriptionId,
          members: widget.args?.members ?? const [],
          date: _selectedDate,
        ),
        initialDate: _selectedDate,
        localeName: context.localization.localeName,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  void _changeDay(int days) {
    final nextDate = DateUtils.dateOnly(
      _selectedDate.add(Duration(days: days)),
    );
    setState(() {
      _selectedDate = nextDate;
    });

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
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030, 12, 31),
      locale: Locale(locale.localeName),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    final cleanDate = DateUtils.dateOnly(pickedDate);
    setState(() {
      _selectedDate = cleanDate;
    });

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
        date: _selectedDate,
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
        date: _selectedDate,
        memberName: state.displayName,
        slot: slot,
        restaurant: restaurantOption,
        restaurantName: restaurant.name,
        viewModel: _viewModel,
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = context.localization;
    return DateFormat.yMMMMEEEEd(locale.localeName).format(date);
  }

  List<FamilyDayMemberEntity> _buildSelectorMembers(
    BuildContext context,
    FamilyCalendarState state,
  ) {
    final locale = context.localization;

    if (state.members.isNotEmpty) {
      return state.members.map((m) {
        return FamilyDayMemberEntity(
          name: m.displayName,
          ageLabel: m.ageYears == null
              ? ''
              : locale.family_member_age_years(m.ageYears!),
          statusLabel: m.isPaused
              ? locale.family_member_paused_label
              : locale.family_member_active_label,
          imageAsset: Assets.profileAvatar,
          memberId: m.memberId,
          subscriptionId: m.subscriptionId,
        );
      }).toList();
    }

    if (widget.args != null && (state.displayName.isNotEmpty)) {
      return [
        FamilyDayMemberEntity(
          name: state.displayName,
          ageLabel: '',
          statusLabel: locale.family_member_active_label,
          imageAsset: Assets.profileAvatar,
          memberId: widget.args?.memberId,
          subscriptionId: widget.args?.subscriptionId,
        ),
      ];
    }

    return const [];
  }

  FamilyDayMealIconType _mapSlotToIconType(String slot) {
    return switch (slot.toLowerCase().trim()) {
      'breakfast' || 'إفطار' || 'فطور' => FamilyDayMealIconType.breakfast,
      'lunch' || 'غداء' => FamilyDayMealIconType.lunch,
      'dinner' || 'عشاء' => FamilyDayMealIconType.dinner,
      _ => FamilyDayMealIconType.snack,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilyCalendarViewModel>.value(
      value: _viewModel,
      child: BlocBuilder<FamilyCalendarViewModel, FamilyCalendarState>(
        builder: (context, state) {
          final selectorMembers = _buildSelectorMembers(context, state);
          final safeSelectedMemberIndex = selectorMembers.isEmpty
              ? 0
              : state.selectedMemberIndex
                    .clamp(0, selectorMembers.length - 1)
                    .toInt();
          final selectedMember = selectorMembers.isNotEmpty
              ? selectorMembers[safeSelectedMemberIndex]
              : FamilyDayMemberEntity(
                  name: state.displayName,
                  ageLabel: '',
                  statusLabel: locale.family_member_active_label,
                  imageAsset: Assets.profileAvatar,
                );

          final day = state.selectedDay;
          final restaurantName = day?.restaurant?.name ?? '';
          final dayMeals = day?.meals ?? const [];

          final title = locale.family_day_screen_title;

          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              titleWidget: Text(
                title,
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
                    if (selectorMembers.isNotEmpty)
                      FamilyDayMemberSelector(
                        members: selectorMembers,
                        selectedIndex: safeSelectedMemberIndex,
                        onMemberSelected: (index) {
                          _viewModel.doIntent(
                            SelectFamilyMemberEvent(
                              index: index,
                              localeName: locale.localeName,
                            ),
                          );
                        },
                      ),
                    FamilyDayHeader(
                      dateLabel: _formatDate(context, _selectedDate),
                      onPreviousDay: () => _changeDay(-1),
                      onNextDay: () => _changeDay(1),
                      onDatePressed: _openDatePicker,
                    ),
                    FamilyDayMemberCard(member: selectedMember),
                    const SizedBox(height: Spacing.familyDayMemberTopGap),
                    FamilyDayCurrentRestaurantCard(
                      restaurantName: restaurantName,
                      onChangeRestaurant: () => _openRestaurants(),
                    ),
                    const SizedBox(height: Spacing.familyDayMemberTopGap),
                    if (state.isLoadingCalendar && !state.hasCalendarData)
                      const FamilyDayMealsLoadingSkeleton()
                    else if (state.calendarFailure != null &&
                        !state.hasCalendarData)
                      ApiErrorWidget(
                        exception: state.calendarFailure!.exception,
                        onRetry: () {
                          _viewModel.doIntent(
                            RetryFamilyCalendarEvent(
                              localeName: locale.localeName,
                            ),
                          );
                        },
                      )
                    else if (dayMeals.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.md,
                        ),
                        child: FamilyDayMealCard(
                          meal: FamilyDayMealEntity(
                            mealType: locale.calendar_title,
                            restaurantName: restaurantName,
                            mealName: locale.family_member_choose_meal,
                            actionLabel: locale.family_review_edit_button,
                            imageAsset: Assets.profileBillingPlanBottle,
                            iconType: FamilyDayMealIconType.lunch,
                            isEmpty: true,
                          ),
                          onEditPressed: () => _openRestaurants(null),
                        ),
                      )
                    else
                      for (final meal in dayMeals) ...[
                        FamilyDayMealCard(
                          meal: FamilyDayMealEntity(
                            mealType: meal.mealType.isNotEmpty
                                ? meal.mealType
                                : (meal.slot.isNotEmpty ? meal.slot : ''),
                            restaurantName: restaurantName,
                            mealName: meal.title,
                            actionLabel: locale.family_review_edit_button,
                            imageAsset: meal.imageAsset,
                            imageUrl: meal.imageUrl,
                            iconType: _mapSlotToIconType(meal.slot),
                            calories: meal.calories,
                            carbs: meal.carbs,
                            protein: meal.protein,
                            fat: meal.fat,
                          ),
                          onEditPressed: () => _openMeals(
                            meal.slot.isNotEmpty ? meal.slot : meal.mealType,
                          ),
                        ),
                        const SizedBox(height: Spacing.familyDayMealListGap),
                      ],
                    const SizedBox(height: Spacing.familyDayReviewButtonTopGap),
                    FamilyDayReviewButton(
                      label: locale.family_day_review_meals_button,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.familyReviewMemberMeals,
                          arguments: FamilyReviewMemberMealsArgs(
                            subscriptionId:
                                state.activeSubscriptionId ??
                                widget.args?.subscriptionId ??
                                '',
                            date: _selectedDate,
                            memberName: state.displayName.isNotEmpty
                                ? state.displayName
                                : (widget.args?.memberName ?? ''),
                            memberId: widget.args?.memberId,
                            viewModel: _viewModel,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Spacing.familyDaySelectedTopGap),
                    FamilyDaySelectedStatus(
                      label: dayMeals.isNotEmpty
                          ? locale.family_day_all_meals_selected
                          : locale.family_member_no_meals_selected,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
