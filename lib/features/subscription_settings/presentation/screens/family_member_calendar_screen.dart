import 'package:animations/animations.dart';
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
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_restaurants_args.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_day_summary_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_empty_meals.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_meals_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_primary_action.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_selected_meals_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/staggered_slide_item.dart';

class FamilyMemberCalendarScreen extends StatefulWidget {
  const FamilyMemberCalendarScreen({super.key, this.args, this.viewModel});

  final FamilyMemberCalendarArgs? args;
  final FamilyCalendarViewModel? viewModel;

  @override
  State<FamilyMemberCalendarScreen> createState() =>
      _FamilyMemberCalendarScreenState();
}

class _FamilyMemberCalendarScreenState
    extends State<FamilyMemberCalendarScreen> {
  late final FamilyCalendarViewModel _viewModel;
  bool _isCalendarExpanded = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _viewModel =
        widget.viewModel ??
        (getIt.isRegistered<FamilyCalendarViewModel>()
            ? getIt<FamilyCalendarViewModel>()
            : FamilyCalendarViewModel());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _viewModel.doIntent(
      InitFamilyCalendarEvent(
        args: widget.args,
        initialDate: widget.args?.date,
        localeName: context.localization.localeName,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.close();
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

    return BlocProvider<FamilyCalendarViewModel>.value(
      value: _viewModel,
      child: BlocBuilder<FamilyCalendarViewModel, FamilyCalendarState>(
        buildWhen: (previous, current) =>
            previous.members != current.members ||
            previous.selectedMemberIndex != current.selectedMemberIndex ||
            previous.displayName != current.displayName ||
            previous.isLoadingMembers != current.isLoadingMembers ||
            previous.isLoadingCalendar != current.isLoadingCalendar ||
            previous.activeSubscriptionId != current.activeSubscriptionId ||
            previous.selectedDay != current.selectedDay ||
            previous.visibleMonth != current.visibleMonth ||
            previous.days != current.days ||
            previous.calendarFailure != current.calendarFailure ||
            previous.dayFailure != current.dayFailure,
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
                    if (state.isLoadingMembers)
                      const FamilyMemberCalendarLoadingSkeleton(
                        includeMemberSelector: true,
                      )
                    else ...[
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
                      const SizedBox(
                        height: Spacing.familyMemberCalendarMonthTopGap,
                      ),
                      _buildBody(context, state),
                    ],
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
    final color = context.colorScheme;
    final locale = context.localization;
    final subId = state.activeSubscriptionId;

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

    if (state.isLoadingCalendar) {
      return const FamilyMemberCalendarLoadingSkeleton(
        includeMemberSelector: false,
      );
    }

    if (state.calendarFailure != null && !state.hasCalendarData) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
        child: ApiErrorWidget(
          exception: state.calendarFailure!.exception,
          onRetry: () {
            _viewModel.doIntent(
              RetryFamilyCalendarEvent(localeName: locale.localeName),
            );
          },
        ),
      );
    }

    final selectedDate = state.selectedDate ?? DateTime.now();
    final visibleMonth = state.visibleMonth ?? selectedDate;

    // Subscription range clamping:
    // Only subscription days are active and selectable
    final validDates =
        state.days.map((d) => d.date).whereType<DateTime>().toList()..sort();

    final DateTime? minDate = validDates.isNotEmpty ? validDates.first : null;
    final DateTime? maxDate = validDates.isNotEmpty ? validDates.last : null;

    final canGoPrevious =
        minDate == null ||
        DateTime(
          visibleMonth.year,
          visibleMonth.month,
        ).isAfter(DateTime(minDate.year, minDate.month));

    final canGoNext =
        maxDate == null ||
        DateTime(
          visibleMonth.year,
          visibleMonth.month,
        ).isBefore(DateTime(maxDate.year, maxDate.month));

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

    final hasMeals = selectedMealEntities.isNotEmpty;

    return Column(
      children: [
        CalendarPickerPanel(
          monthTitle: intl.DateFormat.yMMMM(
            locale.localeName,
          ).format(visibleMonth),
          days: calendarDays,
          isExpanded: _isCalendarExpanded,
          backgroundColor: color.surface,
          showBottomBorder: false,
          onToggleExpanded: () {
            setState(() => _isCalendarExpanded = !_isCalendarExpanded);
          },
          onMonthChanged: (months) {
            if (months < 0 && !canGoPrevious) return;
            if (months > 0 && !canGoNext) return;
            _viewModel.doIntent(ChangeFamilyCalendarMonthEvent(months: months));
          },
          onDaySelected: (day) {
            if (day.isMuted) return;
            _viewModel.doIntent(
              SelectFamilyCalendarDayEvent(
                day: day,
                localeName: locale.localeName,
              ),
            );
          },
        ),
        const SizedBox(height: Spacing.familyMemberCalendarSelectedMealsTopGap),
        if (state.isLoadingDay)
          const FamilyMemberCalendarMealsLoadingSkeleton()
        else
          PageTransitionSwitcher(
            duration: const Duration(milliseconds: 320),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                fillColor: color.surface,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(
                '${state.currentMember?.memberId}_${selectedDate.year}_${selectedDate.month}_${selectedDate.day}_$hasMeals',
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasMeals) ...[
                    StaggeredSlideItem(
                      key: ValueKey('meals_card_${selectedDate.day}'),
                      index: 0,
                      child: FamilyMemberSelectedMealsCard(
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
                    ),
                    const SizedBox(
                      height: Spacing.familyMemberCalendarDaySummaryTopGap,
                    ),
                    StaggeredSlideItem(
                      key: ValueKey('summary_card_${selectedDate.day}'),
                      index: 1,
                      child: FamilyMemberCalendarDaySummaryCard(
                        summary: daySummary,
                        dayNumber: selectedDate.day,
                      ),
                    ),
                  ] else ...[
                    StaggeredSlideItem(
                      key: ValueKey('empty_meals_${selectedDate.day}'),
                      index: 0,
                      child: const FamilyMemberCalendarEmptyMeals(),
                    ),
                  ],
                  const SizedBox(
                    height: Spacing.familyMemberCalendarButtonTopGap,
                  ),
                  StaggeredSlideItem(
                    key: ValueKey('action_btn_${selectedDate.day}'),
                    index: hasMeals ? 2 : 1,
                    child: FamilyMemberCalendarPrimaryAction(
                      hasMeals: hasMeals,
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
                                state.currentMember?.memberId ??
                                widget.args?.memberId,
                            members: state.members,
                            viewModel: _viewModel,
                          ),
                        );
                      },
                      onShowDetails: () {
                        final activeSubId = state.activeSubscriptionId;
                        if (activeSubId == null || activeSubId.isEmpty) return;

                        final memberId =
                            state.currentMember?.memberId ??
                            widget.args?.memberId;

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
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
