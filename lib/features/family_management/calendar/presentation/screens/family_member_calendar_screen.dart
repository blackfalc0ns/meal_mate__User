import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_app_bar_title.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_errors_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_member_selector_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_picker_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_plan_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_selected_day_section.dart';

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
  late final bool _isViewModelSupplied;
  bool _initialized = false;
  late final DateTime _fallbackDate;

  @override
  void initState() {
    super.initState();
    _fallbackDate = widget.args?.date ?? DateTime.now();
    _isViewModelSupplied = widget.viewModel != null;
    _viewModel = widget.viewModel ?? getIt<FamilyCalendarViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    unawaited(
      _viewModel.doIntent(
        InitFamilyCalendarEvent(
          args: widget.args,
          initialDate: widget.args?.date,
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

  void _selectMember(int index) => unawaited(
    _viewModel.doIntent(
      SelectFamilyMemberEvent(
        index: index,
        localeName: context.localization.localeName,
      ),
    ),
  );
  void _changeMonth(int months) => unawaited(
    _viewModel.doIntent(ChangeFamilyCalendarMonthEvent(months: months)),
  );
  void _selectDay(CalendarDayEntity day) => unawaited(
    _viewModel.doIntent(
      SelectFamilyCalendarDayEvent(
        day: day,
        localeName: context.localization.localeName,
      ),
    ),
  );
  void _retryCalendar() => unawaited(
    _viewModel.doIntent(
      RetryFamilyCalendarEvent(localeName: context.localization.localeName),
    ),
  );
  void _retryDay() => unawaited(
    _viewModel.doIntent(
      RetryFamilyCalendarDayEvent(localeName: context.localization.localeName),
    ),
  );

  void _chooseMeals() {
    final state = _viewModel.state;
    final subId = state.activeSubscriptionId;
    if (subId == null || subId.isEmpty) return;
    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.familyRestaurants,
        arguments: FamilyRestaurantsArgs(
          subscriptionId: subId,
          date: state.selectedDate ?? _fallbackDate,
          memberName: state.displayName,
          memberId: state.currentMember?.memberId ?? widget.args?.memberId,
          members: state.members,
          viewModel: _viewModel,
        ),
      ),
    );
  }

  void _showDetails() {
    final state = _viewModel.state;
    final subId = state.activeSubscriptionId;
    if (subId == null || subId.isEmpty) return;
    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.familyMemberDayDetails,
        arguments: FamilyDayMealsArgs(
          subscriptionId: subId,
          date: state.selectedDate ?? _fallbackDate,
          memberName: state.displayName,
          memberId: state.currentMember?.memberId ?? widget.args?.memberId,
          members: state.members,
          viewModel: _viewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return BlocProvider<FamilyCalendarViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          titleWidget: const FamilyMemberCalendarAppBarTitle(),
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
                FamilyMemberCalendarMemberSelectorSection(
                  fallbackMemberId: widget.args?.memberId,
                  fallbackSubscriptionId: widget.args?.subscriptionId,
                  onMemberSelected: _selectMember,
                ),
                const SizedBox(height: Spacing.md),
                FamilyMemberCalendarPlanSection(
                  onRetry: _retryCalendar,
                  child: Column(
                    children: [
                      FamilyMemberCalendarErrorsSection(
                        onRetryCalendar: _retryCalendar,
                        onRetryDay: _retryDay,
                      ),
                      FamilyMemberCalendarPickerSection(
                        fallbackDate: _fallbackDate,
                        onMonthChanged: _changeMonth,
                        onDaySelected: _selectDay,
                      ),
                      const SizedBox(
                        height: Spacing.familyMemberCalendarSelectedMealsTopGap,
                      ),
                      FamilyMemberSelectedDaySection(
                        fallbackDate: _fallbackDate,
                        fallbackMemberId: widget.args?.memberId,
                        onChooseMeals: _chooseMeals,
                        onShowDetails: _showDetails,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
