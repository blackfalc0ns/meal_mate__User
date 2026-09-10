import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_member_calendar_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_restaurants_args.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_day_summary_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_primary_action.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_selected_meals_card.dart';

class FamilyMemberCalendarScreen extends StatefulWidget {
  const FamilyMemberCalendarScreen({super.key, this.args});

  final FamilyMemberCalendarArgs? args;

  @override
  State<FamilyMemberCalendarScreen> createState() =>
      _FamilyMemberCalendarScreenState();
}

class _FamilyMemberCalendarScreenState
    extends State<FamilyMemberCalendarScreen> {
  FamilyCalendarViewModel? _viewModel;
  bool _isCalendarExpanded = false;
  bool _initialized = false;

  // Fallback state for tests without DI
  int _fakeSelectedMemberIndex = 3;
  int _fakeSelectedDay = 20;
  DateTime _fakeVisibleMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (getIt.isRegistered<FamilyCalendarViewModel>()) {
      _viewModel = getIt<FamilyCalendarViewModel>();
    } else {
      _fakeVisibleMonth = const FamilyMemberCalendarFakeDataSource()
          .getCalendar()
          .month;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    if (_viewModel != null) {
      _viewModel!.doIntent(
        InitFamilyCalendarEvent(
          args: widget.args,
          initialDate: widget.args?.date,
          localeName: context.localization.localeName,
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel?.close();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (_viewModel == null) {
      return _buildFakeFallbackScaffold(context);
    }

    return BlocProvider<FamilyCalendarViewModel>.value(
      value: _viewModel!,
      child: BlocBuilder<FamilyCalendarViewModel, FamilyCalendarState>(
        builder: (context, state) {
          final selectorMembers = _buildSelectorMembers(context, state);
          final safeSelectedMemberIndex = selectorMembers.isEmpty
              ? 0
              : state.selectedMemberIndex
                    .clamp(0, selectorMembers.length - 1)
                    .toInt();

          final screenTitle = state.displayName.isNotEmpty
              ? locale.family_member_calendar_title(state.displayName)
              : locale.calendar_title;

          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              titleWidget: Text(
                screenTitle,
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
                  start: Spacing.familyMemberCalendarHorizontalPadding,
                  end: Spacing.familyMemberCalendarHorizontalPadding,
                  top: Spacing.familyMemberCalendarTopGap,
                  bottom: Spacing.xl,
                ),
                child: Column(
                  children: [
                    if (selectorMembers.isNotEmpty)
                      FamilyDayMemberSelector(
                        members: selectorMembers,
                        selectedIndex: safeSelectedMemberIndex,
                        onMemberSelected: (index) {
                          _viewModel!.doIntent(
                            SelectFamilyMemberEvent(
                              index: index,
                              localeName: locale.localeName,
                            ),
                          );
                        },
                      ),
                    const SizedBox(
                      height: Spacing.familyMemberCalendarMonthTopGap,
                    ),
                    _buildBody(context, state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, FamilyCalendarState state) {
    final locale = context.localization;
    final subId = state.activeSubscriptionId;

    if (state.isLoadingMembers) {
      return const FamilyMemberCalendarLoadingSkeleton();
    }

    if (subId == null || subId.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
        child: EmptyStateWidget(
          title: locale.family_member_no_plan,
          description: locale.family_member_no_active_subscription,
          icon: Icons.calendar_month_outlined,
        ),
      );
    }

    if (state.isLoadingCalendar && !state.hasCalendarData) {
      return const FamilyMemberCalendarLoadingSkeleton();
    }

    if (state.calendarFailure != null && !state.hasCalendarData) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
        child: ApiErrorWidget(
          exception: state.calendarFailure!.exception,
          onRetry: () {
            _viewModel!.doIntent(
              RetryFamilyCalendarEvent(localeName: locale.localeName),
            );
          },
        ),
      );
    }

    final selectedDate = state.selectedDate ?? DateTime.now();
    final visibleMonth = state.visibleMonth ?? selectedDate;

    final calendarDays = _isCalendarExpanded
        ? CalendarDaysBuilder.monthDays(
            focusedMonth: visibleMonth,
            selectedDate: state.selectedDate,
            serviceDays: state.days,
          )
        : CalendarDaysBuilder.serviceDays(
            state.days,
            selectedDate: state.selectedDate,
          );

    final selectedDay = state.selectedDay;
    final dayMeals = selectedDay?.meals ?? const [];

    final selectedMealEntities = dayMeals.map((meal) {
      final slotLabel = meal.slot.isNotEmpty
          ? meal.mealType
          : (meal.mealType.isNotEmpty ? meal.mealType : locale.calendar_title);
      final desc = meal.calories.isNotEmpty
          ? locale.family_member_calories_value(meal.calories)
          : meal.description;

      return FamilyCalendarSelectedMealEntity(
        typeLabel: slotLabel,
        name: meal.title,
        description: desc,
        chosenLabel: locale.family_member_meal_chosen,
        imageAsset: meal.imageAsset,
        imageUrl: meal.imageUrl,
      );
    }).toList();

    final formattedDateTitle = intl.DateFormat.yMMMMEEEEd(
      locale.localeName,
    ).format(selectedDate);

    final daySummary = FamilyCalendarDaySummaryEntity(
      title: formattedDateTitle,
      subtitle: locale.family_member_selected_meals_count(
        selectedMealEntities.length,
      ),
    );

    final formattedShortDate = intl.DateFormat.MMMMd(
      locale.localeName,
    ).format(selectedDate);

    return Column(
      children: [
        CalendarPickerPanel(
          monthTitle: intl.DateFormat.yMMMM(
            locale.localeName,
          ).format(visibleMonth),
          days: calendarDays,
          isExpanded: _isCalendarExpanded,
          onToggleExpanded: () {
            setState(() => _isCalendarExpanded = !_isCalendarExpanded);
          },
          onMonthChanged: (months) {
            _viewModel!.doIntent(
              ChangeFamilyCalendarMonthEvent(months: months),
            );
          },
          onDaySelected: (day) {
            _viewModel!.doIntent(
              SelectFamilyCalendarDayEvent(
                day: day,
                localeName: locale.localeName,
              ),
            );
          },
        ),
        const SizedBox(height: Spacing.familyMemberCalendarSelectedMealsTopGap),
        FamilyMemberSelectedMealsCard(
          title: locale.family_member_selected_meals_title,
          subtitle: locale.family_member_selected_meals_subtitle(
            state.displayName,
            formattedShortDate,
          ),
          countLabel: locale.family_member_selected_meals_count(
            selectedMealEntities.length,
          ),
          meals: selectedMealEntities,
        ),
        const SizedBox(height: Spacing.familyMemberCalendarDaySummaryTopGap),
        FamilyMemberCalendarDaySummaryCard(summary: daySummary),
        const SizedBox(height: Spacing.familyMemberCalendarButtonTopGap),
        FamilyMemberCalendarPrimaryAction(
          hasMeals: selectedMealEntities.isNotEmpty,
          canEdit: selectedDay?.isEditable == true,
          onChooseMeals: () {
            final activeSubId = state.activeSubscriptionId;
            if (activeSubId == null || activeSubId.isEmpty) return;
            Navigator.of(context).pushNamed(
              AppRoutes.familyRestaurants,
              arguments: FamilyRestaurantsArgs(
                subscriptionId: activeSubId,
                date: selectedDate,
                memberName: state.displayName,
                memberId:
                    state.currentMember?.memberId ?? widget.args?.memberId,
                members: state.members,
                viewModel: _viewModel,
              ),
            );
          },
          onShowDetails: () {
            final activeSubId = state.activeSubscriptionId;
            if (activeSubId == null || activeSubId.isEmpty) return;

            final memberId =
                state.currentMember?.memberId ?? widget.args?.memberId;

            Navigator.of(context).pushNamed(
              AppRoutes.familyMemberDayDetails,
              arguments: FamilyDayMealsArgs(
                subscriptionId: activeSubId,
                date: selectedDate,
                memberName: state.displayName,
                memberId: memberId,
                members: state.members,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFakeFallbackScaffold(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final calendar = const FamilyMemberCalendarFakeDataSource().getCalendar();

    final selectorMembers = calendar.members;
    final safeSelectedMemberIndex = selectorMembers.isEmpty
        ? 0
        : _fakeSelectedMemberIndex.clamp(0, selectorMembers.length - 1).toInt();

    final selectedDate = DateTime(
      _fakeVisibleMonth.year,
      _fakeVisibleMonth.month,
      _fakeSelectedDay,
    );
    final calendarDays = _isCalendarExpanded
        ? _fakeMonthDays(
            focusedMonth: _fakeVisibleMonth,
            selectedDate: selectedDate,
          )
        : _fakeServiceDays(selectedDate: selectedDate);

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: Text(
          calendar.title,
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
            start: Spacing.familyMemberCalendarHorizontalPadding,
            end: Spacing.familyMemberCalendarHorizontalPadding,
            top: Spacing.familyMemberCalendarTopGap,
            bottom: Spacing.xl,
          ),
          child: Column(
            children: [
              FamilyDayMemberSelector(
                members: selectorMembers,
                selectedIndex: safeSelectedMemberIndex,
                onMemberSelected: (index) {
                  setState(() => _fakeSelectedMemberIndex = index);
                },
              ),
              const SizedBox(height: Spacing.familyMemberCalendarMonthTopGap),
              CalendarPickerPanel(
                monthTitle: intl.DateFormat.yMMMM(
                  locale.localeName,
                ).format(_fakeVisibleMonth),
                days: calendarDays,
                isExpanded: _isCalendarExpanded,
                onToggleExpanded: () {
                  setState(() => _isCalendarExpanded = !_isCalendarExpanded);
                },
                onMonthChanged: (months) {
                  setState(() {
                    _fakeVisibleMonth = DateTime(
                      _fakeVisibleMonth.year,
                      _fakeVisibleMonth.month + months,
                    );
                  });
                },
                onDaySelected: (day) {
                  setState(() {
                    _fakeSelectedDay = day.dayNumber;
                    final date = day.date;
                    if (date != null &&
                        (_fakeVisibleMonth.year != date.year ||
                            _fakeVisibleMonth.month != date.month)) {
                      _fakeVisibleMonth = DateTime(date.year, date.month);
                    }
                  });
                },
              ),
              const SizedBox(
                height: Spacing.familyMemberCalendarSelectedMealsTopGap,
              ),
              FamilyMemberSelectedMealsCard(
                title: calendar.selectedMealsTitle,
                subtitle: calendar.selectedMealsSubtitle,
                countLabel: calendar.selectedMealsCountLabel,
                meals: calendar.selectedMeals,
              ),
              const SizedBox(
                height: Spacing.familyMemberCalendarDaySummaryTopGap,
              ),
              FamilyMemberCalendarDaySummaryCard(summary: calendar.daySummary),
              const SizedBox(height: Spacing.familyMemberCalendarButtonTopGap),
              FamilyDayReviewButton(
                label: calendar.detailsButtonLabel,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.familyMemberDayDetails),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CalendarDayEntity> _fakeServiceDays({required DateTime selectedDate}) {
    final firstDay = selectedDate.subtract(const Duration(days: 4));

    return List.generate(7, (index) {
      final date = firstDay.add(Duration(days: index));
      return _fakeCalendarDay(date, selectedDate: selectedDate);
    });
  }

  List<CalendarDayEntity> _fakeMonthDays({
    required DateTime focusedMonth,
    required DateTime selectedDate,
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

      return _fakeCalendarDay(
        date,
        selectedDate: selectedDate,
        isMuted: date.month != focusedMonth.month,
      );
    });
  }

  CalendarDayEntity _fakeCalendarDay(
    DateTime date, {
    required DateTime selectedDate,
    bool isMuted = false,
  }) {
    return CalendarDayEntity(
      dayNumber: date.day,
      weekday: intl.DateFormat.E(context.localization.localeName).format(date),
      date: date,
      isSelected:
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      isMuted: isMuted,
      hasMeals: date.day % 5 == 0 || date.day == selectedDate.day,
    );
  }
}
