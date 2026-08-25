import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_pick_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_summary_card.dart';

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
  bool _mealSheetOpen = false;
  bool _didLoad = false;

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
            previous.isSaving != current.isSaving,
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
    final readOnly = selectedDay?.isEditable != true;

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
            _viewModel.doIntent(SelectCalendarDayEvent(day));
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              start: Spacing.screenH,
              end: Spacing.screenH,
              top: Spacing.xxxl,
              bottom: widget.showBottomSpace
                  ? Spacing.bottomNavHeight + Spacing.xxxl
                  : Spacing.xl,
            ),
            child: Column(
              children: [
                if (restaurant == null)
                  CalendarRestaurantPickCard(
                    onTap: readOnly
                        ? null
                        : () => _openRestaurantPicker(context),
                  )
                else
                  CalendarRestaurantSummaryCard(
                    restaurant: restaurant,
                    meals: meals,
                    onMorePressed: readOnly
                        ? null
                        : () => _openRestaurantPicker(context),
                  ),
                const SizedBox(height: Spacing.xl),
                for (final meal in meals) ...[
                  CalendarMealCard(
                    meal: meal,
                    readOnly: readOnly,
                    onChangeMeal: () => _viewModel.doIntent(
                      LoadCalendarAvailableMealsEvent(
                        localeName: locale.localeName,
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleStateSideEffects(BuildContext context, CalendarState state) {
    if (state.availableMeals != null && !_mealSheetOpen) {
      _openMealPicker(context);
    }

    if (_mealSheetOpen &&
        !state.isSaving &&
        state.saveFailure == null &&
        state.availableMeals == null) {
      Navigator.of(context).maybePop();
      _mealSheetOpen = false;
    }
  }

  Future<void> _openRestaurantPicker(BuildContext context) async {
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
                  if (sheetState.isRestaurantsLoading &&
                      !sheetState.hasRestaurantPool) {
                    return const Center(child: CircularProgressIndicator());
                  }

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
                    onRestaurantSelected: (restaurant) {
                      Navigator.pop(sheetContext, restaurant);
                    },
                  );
                },
              ),
            );
          },
        );

    if (selectedRestaurant == null || !mounted) return;

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
    final locale = context.localization;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      builder: (_) {
        return BlocProvider<CalendarViewModel>.value(
          value: _viewModel,
          child: BlocBuilder<CalendarViewModel, CalendarState>(
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
                onSave: () {
                  _viewModel.doIntent(
                    SaveCalendarDayMealsEvent(localeName: locale.localeName),
                  );
                },
                canSave: state.canSaveMeals,
                isSaving: state.isSaving,
                failure: state.availableMealsFailure ?? state.saveFailure,
              );
            },
          ),
        );
      },
    );
    _mealSheetOpen = false;
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

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
