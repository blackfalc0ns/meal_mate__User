import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_summary_card.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    this.showBottomSpace = false,
    this.subscriptionId,
  });

  final bool showBottomSpace;
  final String? subscriptionId;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CalendarViewModel _viewModel;
  late DateTime _focusedMonth;
  bool _isExpanded = false;
  bool _restaurantSheetOpen = false;
  bool _mealSheetOpen = false;
  bool _suppressMealSheetAutoOpen = false;
  bool _didLoad = false;
  int _handledSaveSuccessCount = 0;
  Route<void>? _mealPickerRoute;
  final RoundedLoadingButtonController _mealSaveButtonController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _focusedMonth = DateTime(today.year, today.month);
    _viewModel = getIt<CalendarViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    _viewModel.doIntent(
      LoadCalendarEvent(
        subscriptionId: widget.subscriptionId,
        localeName: context.localization.localeName,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<CalendarViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<CalendarViewModel, CalendarState>(
        listenWhen: (previous, current) =>
            previous.availableMeals != current.availableMeals ||
            previous.isAvailableMealsLoading !=
                current.isAvailableMealsLoading ||
            previous.isSaving != current.isSaving ||
            previous.saveSuccessCount != current.saveSuccessCount,
        listener: _handleStateSideEffects,
        builder: (context, state) {
          final selectedDate = state.selectedDate;
          if (selectedDate != null &&
              (_focusedMonth.year != selectedDate.year ||
                  _focusedMonth.month != selectedDate.month)) {
            _focusedMonth = DateTime(selectedDate.year, selectedDate.month);
          }

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: color.primary,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: color.surface,
              body: Column(
                children: [
                  CalendarHeader(title: locale.calendar_title),
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CalendarState state) {
    final locale = context.localization;

    if (state.isCalendarLoading && !state.hasCalendarData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasNoSubscription) {
      return Padding(
        padding: const EdgeInsets.all(Spacing.screenH),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStateWidget(
              title: locale.billing_no_subscription_title,
              description: locale.billing_no_subscription_description,
              icon: Icons.calendar_month_rounded,
            ),
            const SizedBox(height: Spacing.lg),
            AppButton(
              text: locale.subscription_details_subscribe_now,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.subscriptions),
            ),
          ],
        ),
      );
    }

    if (state.calendarFailure != null && !state.hasCalendarData) {
      return ApiErrorWidget(
        exception: state.calendarFailure!.exception,
        onRetry: () => _viewModel.doIntent(
          LoadCalendarEvent(
            subscriptionId: state.subscriptionId,
            localeName: locale.localeName,
          ),
        ),
      );
    }

    if (!state.hasCalendarData) {
      return EmptyStateWidget(
        title: locale.calendar_title,
        description: locale.billing_no_subscription_description,
        icon: Icons.calendar_month_rounded,
      );
    }

    final selectedDay = state.selectedDay;
    final days = _isExpanded
        ? _monthDays(
            focusedMonth: _focusedMonth,
            selectedDate: state.selectedDate,
            serviceDays: state.days,
          )
        : _serviceDays(state.days, selectedDate: state.selectedDate);
    final restaurant = selectedDay?.restaurant;
    final meals = selectedDay?.meals ?? const [];
    final selectedMeals = meals.where((meal) => meal.selected).toList();
    final readOnly = selectedDay?.isEditable != true;
    final hasMeals = meals.isNotEmpty;

    return Column(
      children: [
        CalendarPickerPanel(
          monthTitle: DateFormat.yMMMM(locale.localeName).format(_focusedMonth),
          days: days,
          isExpanded: _isExpanded,
          onToggleExpanded: () {
            setState(() => _isExpanded = !_isExpanded);
          },
          onMonthChanged: _changeMonth,
          onDaySelected: (day) {
            _viewModel.doIntent(
              SelectCalendarDayEvent(day: day, localeName: locale.localeName),
            );
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              start: Spacing.screenH,
              end: Spacing.screenH,
              top: hasMeals ? Spacing.xxxl : Spacing.calendarEmptyMealsTopGap,
              bottom: widget.showBottomSpace
                  ? Spacing.bottomNavHeight + Spacing.xxxl
                  : Spacing.xl,
            ),
            child: Column(
              children: [
                if (!hasMeals)
                  CalendarEmptyMealsState(
                    onAddMeals: readOnly
                        ? null
                        : () => _openRestaurantPicker(context),
                  )
                else ...[
                  if (restaurant != null) ...[
                    CalendarRestaurantSummaryCard(
                      key: ValueKey(
                        '${selectedDay?.date?.toIso8601String() ?? ''}'
                        '-${_mealsSignature(selectedMeals)}',
                      ),
                      restaurant: restaurant,
                      day: selectedDay,
                      onMorePressed: readOnly
                          ? null
                          : () => _openRestaurantPicker(context),
                    ),
                    const SizedBox(height: Spacing.xl),
                  ],
                  for (final meal in meals) ...[
                    CalendarMealCard(
                      meal: meal,
                      readOnly: readOnly,
                      onTap: () => _openMealDetails(context, meal, restaurant),
                      onChangeMeal: () {
                        _suppressMealSheetAutoOpen = false;
                        _openMealPicker(context);
                        _viewModel.doIntent(
                          LoadCalendarAvailableMealsEvent(
                            localeName: locale.localeName,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Spacing.md),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleStateSideEffects(BuildContext context, CalendarState state) {
    if (state.availableMeals != null &&
        !_mealSheetOpen &&
        !_suppressMealSheetAutoOpen) {
      _openMealPicker(context);
    }

    if (_mealSheetOpen &&
        state.saveSuccessCount != _handledSaveSuccessCount &&
        !state.isSaving &&
        state.saveFailure == null &&
        state.availableMeals == null) {
      _handledSaveSuccessCount = state.saveSuccessCount;
      CustomSnackbar.showSuccess(
        context: context,
        message: context.localization.calendar_meals_save_success,
      );
      _closeMealPickerRoute();
      _mealSaveButtonController.reset();
      return;
    }

    if (_mealSheetOpen) {
      if (state.isSaving) {
        _mealSaveButtonController.start();
      } else {
        _mealSaveButtonController.stop();
      }
    }
  }

  Future<void> _openRestaurantPicker(BuildContext context) async {
    if (_restaurantSheetOpen) return;
    _restaurantSheetOpen = true;
    final locale = context.localization;
    _viewModel.doIntent(
      LoadCalendarRestaurantsEvent(localeName: locale.localeName),
    );

    final selectedRestaurant =
        await showModalBottomSheet<CalendarRestaurantOptionEntity>(
          context: context,
          isScrollControlled: true,
          backgroundColor: context.colorScheme.surface,
          builder: (sheetContext) {
            return BlocProvider<CalendarViewModel>.value(
              value: _viewModel,
              child: BlocBuilder<CalendarViewModel, CalendarState>(
                builder: (context, sheetState) {
                  final failure = sheetState.restaurantsFailure;
                  if (failure != null && !sheetState.hasRestaurantPool) {
                    return ApiErrorWidget(
                      exception: failure.exception,
                      onRetry: () => _viewModel.doIntent(
                        LoadCalendarRestaurantsEvent(
                          localeName: locale.localeName,
                        ),
                      ),
                    );
                  }

                  return CalendarRestaurantPickerSheet(
                    restaurants: sheetState.restaurantsWithUsageLimits(),
                    isLoading: sheetState.isRestaurantsLoading,
                    onRestaurantSelected: (restaurant) {
                      Navigator.pop(sheetContext, restaurant);
                    },
                  );
                },
              ),
            );
          },
        );

    _restaurantSheetOpen = false;

    if (selectedRestaurant == null || !mounted) return;

    _suppressMealSheetAutoOpen = false;
    _viewModel.doIntent(
      SelectCalendarRestaurantEvent(
        restaurant: selectedRestaurant,
        localeName: locale.localeName,
      ),
    );
  }

  Future<void> _openMealPicker(BuildContext context) async {
    if (_mealSheetOpen) return;
    _mealSheetOpen = true;
    final route = MaterialPageRoute<void>(
      builder: (_) {
        return BlocProvider<CalendarViewModel>.value(
          value: _viewModel,
          child: Stack(
            children: [
              BlocBuilder<CalendarViewModel, CalendarState>(
                builder: (context, state) {
                  final restaurant =
                      state.availableMeals?.restaurant ??
                      state.selectedDay?.restaurant;
                  return CalendarMealPickerSheet(
                    restaurantName: restaurant?.name,
                    restaurantLogoUrl: restaurant?.logoUrl,
                    restaurantInitials: _initials(restaurant?.name ?? ''),
                    restaurantRating: restaurant?.rating,
                    availableMeals: state.availableMeals,
                    selectedMealIds: state.localSelectedMealIds,
                    onMealToggled: (mealId) {
                      _viewModel.doIntent(ToggleCalendarMealEvent(mealId));
                    },
                    onSave: null,
                    canSave: false,
                    isLoading: state.isAvailableMealsLoading,
                    isSaving: false,
                    failure: state.availableMealsFailure ?? state.saveFailure,
                    isFullPage: true,
                    bottomContentPadding: Spacing.bottomNavHeight + Spacing.xxl,
                  );
                },
              ),
              PositionedDirectional(
                start: Spacing.lg,
                end: Spacing.lg,
                bottom: Spacing.xl,
                child:
                    BlocSelector<
                      CalendarViewModel,
                      CalendarState,
                      ({bool canSave, bool isSaving})
                    >(
                      selector: (state) => (
                        canSave: state.canSaveMeals,
                        isSaving: state.isSaving,
                      ),
                      builder: (context, buttonState) {
                        final color = context.colorScheme;
                        final locale = context.localization;
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return RoundedLoadingButton(
                              controller: _mealSaveButtonController,
                              onPressed: buttonState.canSave
                                  ? () {
                                      _viewModel.doIntent(
                                        SaveCalendarDayMealsEvent(
                                          localeName: locale.localeName,
                                        ),
                                      );
                                    }
                                  : null,
                              animateOnTap: false,
                              resetAfterDuration: false,
                              height: Spacing.buttonHeight,
                              width: constraints.maxWidth,
                              borderRadius: Spacing.buttonRadius,
                              elevation: 0,
                              color: color.primary,
                              successColor: color.primary,
                              disabledColor: color.outlineVariant,
                              valueColor: color.onPrimary,
                              child: Text(
                                locale.calendar_done,
                                locale: Locale(locale.localeName),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size16,
                                  color: color.onPrimary,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
    _mealPickerRoute = route;
    await Navigator.of(context).push<void>(route);
    if (identical(_mealPickerRoute, route)) {
      _mealPickerRoute = null;
    }
    _mealSheetOpen = false;
    if (_viewModel.state.isAvailableMealsLoading ||
        _viewModel.state.availableMeals != null) {
      _suppressMealSheetAutoOpen = true;
    }
  }

  void _closeMealPickerRoute() {
    final route = _mealPickerRoute;
    final navigator = route?.navigator;
    _mealSheetOpen = false;
    _mealPickerRoute = null;

    if (route == null || navigator == null) return;
    if (route.isCurrent) {
      navigator.pop();
      return;
    }
    if (route.isActive) {
      navigator.removeRoute(route);
    }
  }

  void _changeMonth(int direction) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + direction,
      );
    });
  }

  List<CalendarDayEntity> _serviceDays(
    List<CalendarDayEntity> days, {
    required DateTime? selectedDate,
  }) {
    return days
        .map(
          (day) => day.copyWith(
            isSelected: _isSameDay(day.date, selectedDate),
            isMuted: false,
          ),
        )
        .toList();
  }

  List<CalendarDayEntity> _monthDays({
    required DateTime focusedMonth,
    required DateTime? selectedDate,
    required List<CalendarDayEntity> serviceDays,
  }) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
    final leadingDays = (firstDay.weekday + 1) % 7;
    final gridStart = firstDay.subtract(Duration(days: leadingDays));
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final totalCells = ((leadingDays + daysInMonth + 6) ~/ 7) * 7;

    return List.generate(totalCells, (index) {
      final date = DateTime(
        gridStart.year,
        gridStart.month,
        gridStart.day + index,
      );
      final serviceDay = serviceDays
          .where((day) => _isSameDay(day.date, date))
          .firstOrNull;
      if (serviceDay != null) {
        return serviceDay.copyWith(
          isSelected: _isSameDay(serviceDay.date, selectedDate),
          isMuted: false,
        );
      }
      return CalendarDayEntity(
        dayNumber: date.day,
        weekday: '',
        date: date,
        isMuted: true,
        hasMeals: false,
      );
    });
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    return a != null &&
        b != null &&
        a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String _mealsSignature(List<CalendarMealEntity> meals) {
    return meals
        .map(
          (meal) =>
              '${meal.id}:${meal.protein}:${meal.carbs}:${meal.fat}:${meal.calories}',
        )
        .join('|');
  }

  void _openMealDetails(
    BuildContext context,
    CalendarMealEntity meal,
    CalendarRestaurantEntity? restaurant,
  ) {
    final locale = context.localization;
    final restaurantName = restaurant?.name.isNotEmpty == true
        ? restaurant!.name
        : locale.calendar_restaurant_name;

    final proteinG = _parseNullableInt(meal.protein);
    final carbsG = _parseNullableInt(meal.carbs);
    final fatG = _parseNullableInt(meal.fat);

    Navigator.of(context).pushNamed(
      AppRoutes.mealDetails,
      arguments: MealDetailsEntity(
        title: meal.title,
        description: meal.description.isNotEmpty
            ? meal.description
            : locale.search_meal_description,
        restaurantName: restaurantName,
        restaurantLogo: _initials(restaurantName),
        restaurantLogoUrl: restaurant?.logoUrl,
        headerImageUrl: meal.imageUrl,
        ratingTitle: locale.localeName == 'ar'
            ? 'تقييم المطعم'
            : 'Restaurant rating',
        ratingValue: restaurant?.rating ?? '',
        programLabel: locale.localeName == 'ar' ? 'نوع الوجبة' : 'Meal type',
        programValue: meal.mealType,
        deliveryLabel: locale.localeName == 'ar'
            ? 'وقت التوصيل'
            : 'Delivery time',
        deliveryValue: restaurant?.deliveryWindow ?? '',
        ingredientsTitle: locale.calendar_ingredients,
        ingredients: meal.ingredients
            .map(
              (ingredient) => MealDetailsIngredientEntity(
                label: ingredient.label,
                asset: ingredient.asset,
                iconUrl: ingredient.iconUrl,
              ),
            )
            .where((ingredient) => ingredient.label.isNotEmpty)
            .toList(),
        nutritionTitle: locale.localeName == 'ar'
            ? 'القيم الغذائية'
            : 'Nutrition facts',
        nutritionItems: [
          MealDetailsNutritionEntity(
            value: _gramValue(null, locale.localeName),
            label: locale.localeName == 'ar' ? 'ألياف' : 'Fiber',
            type: MealDetailsNutritionType.fiber,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(proteinG, locale.localeName),
            label: locale.calendar_protein,
            type: MealDetailsNutritionType.protein,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(carbsG, locale.localeName),
            label: locale.calendar_carbs,
            type: MealDetailsNutritionType.carbs,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(fatG, locale.localeName),
            label: locale.calendar_fat,
            type: MealDetailsNutritionType.fat,
          ),
          MealDetailsNutritionEntity(
            value: meal.calories.isNotEmpty ? meal.calories : '-',
            label: locale.calendar_calories,
            type: MealDetailsNutritionType.calories,
          ),
        ],
        macroDistributionTitle: locale.localeName == 'ar'
            ? 'توزيع العناصر الغذائية'
            : 'Macro distribution',
        macroItems: _macroItems(
          proteinG,
          carbsG,
          fatG,
          locale.localeName,
          locale,
        ),
        allergensTitle: locale.localeName == 'ar'
            ? 'مسببات الحساسية'
            : 'Allergens',
        allergens: const [],
      ),
    );
  }

  List<MealDetailsMacroEntity> _macroItems(
    int? proteinG,
    int? carbsG,
    int? fatG,
    String localeName,
    AppLocalizations locale,
  ) {
    final fatCalories = (fatG ?? 0) * 9;
    final proteinCalories = (proteinG ?? 0) * 4;
    final carbsCalories = (carbsG ?? 0) * 4;
    final total = fatCalories + proteinCalories + carbsCalories;

    return [
      MealDetailsMacroEntity(
        percent: _percent(fatCalories, total),
        label: locale.calendar_fat,
        value: _gramValue(fatG, localeName),
        type: MealDetailsNutritionType.fat,
      ),
      MealDetailsMacroEntity(
        percent: _percent(proteinCalories, total),
        label: locale.calendar_protein,
        value: _gramValue(proteinG, localeName),
        type: MealDetailsNutritionType.protein,
      ),
      MealDetailsMacroEntity(
        percent: _percent(carbsCalories, total),
        label: locale.calendar_carbs,
        value: _gramValue(carbsG, localeName),
        type: MealDetailsNutritionType.carbs,
      ),
    ];
  }

  String _percent(int value, int total) {
    if (total == 0) return '-';
    return '%${((value / total) * 100).round()}';
  }

  String _gramValue(int? value, String localeName) {
    if (value == null) return '-';
    return localeName == 'ar' ? '$value جم' : '${value}g';
  }

  int? _parseNullableInt(String value) {
    if (value.isEmpty) return null;
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
