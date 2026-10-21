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
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_app_bar_title.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_errors_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_member_selector_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_picker_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_plan_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_selected_day_section.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

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

  @override
  void initState() {
    super.initState();
    _isViewModelSupplied = widget.viewModel != null;
    _viewModel = widget.viewModel ?? getIt<FamilyCalendarViewModel>();
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
    if (!_isViewModelSupplied) {
      _viewModel.close();
    }
    super.dispose();
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
                BlocSelector<
                  FamilyCalendarViewModel,
                  FamilyCalendarState,
                  ({
                    List<FamilyMemberSummaryEntity> members,
                    int selectedIndex,
                    String displayName,
                    bool isLoading,
                  })
                >(
                  selector: (state) => (
                    members: state.members,
                    selectedIndex: state.selectedMemberIndex,
                    displayName: state.displayName,
                    isLoading: state.isLoadingMembers,
                  ),
                  builder: (context, data) {
                    return FamilyMemberCalendarMemberSelectorSection(
                      members: data.members,
                      selectedIndex: data.selectedIndex,
                      fallbackDisplayName: data.displayName,
                      fallbackMemberId: widget.args?.memberId,
                      fallbackSubscriptionId: widget.args?.subscriptionId,
                      isLoading: data.isLoading,
                      onMemberSelected: (index) {
                        _viewModel.doIntent(
                          SelectFamilyMemberEvent(
                            index: index,
                            localeName: locale.localeName,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: Spacing.familyMemberCalendarMonthTopGap),
                FamilyMemberCalendarPlanSection(
                  onRetry: () => _viewModel.doIntent(
                    RetryFamilyCalendarEvent(localeName: locale.localeName),
                  ),
                  child: Column(
                    children: [
                      FamilyMemberCalendarErrorsSection(
                        onRetryCapabilities: () => _viewModel.doIntent(
                          const RetryFamilyCapabilitiesEvent(),
                        ),
                        onRetryCalendar: () => _viewModel.doIntent(
                          RetryFamilyCalendarEvent(
                            localeName: locale.localeName,
                          ),
                        ),
                        onRetryDay: () => _viewModel.doIntent(
                          RetryFamilyCalendarDayEvent(
                            localeName: locale.localeName,
                          ),
                        ),
                      ),
                      BlocSelector<
                        FamilyCalendarViewModel,
                        FamilyCalendarState,
                        ({
                          DateTime visibleMonth,
                          DateTime? selectedDate,
                          List<CalendarDayEntity> days,
                        })
                      >(
                        selector: (state) => (
                          visibleMonth:
                              state.visibleMonth ??
                              state.selectedDate ??
                              DateTime.now(),
                          selectedDate: state.selectedDate,
                          days: state.days,
                        ),
                        builder: (context, data) {
                          return FamilyMemberCalendarPickerSection(
                            visibleMonth: data.visibleMonth,
                            selectedDate: data.selectedDate,
                            serviceDays: data.days,
                            onMonthChanged: (months) {
                              _viewModel.doIntent(
                                ChangeFamilyCalendarMonthEvent(months: months),
                              );
                            },
                            onDaySelected: (day) {
                              _viewModel.doIntent(
                                SelectFamilyCalendarDayEvent(
                                  day: day,
                                  localeName: locale.localeName,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: Spacing.familyMemberCalendarSelectedMealsTopGap,
                      ),
                      BlocSelector<
                        FamilyCalendarViewModel,
                        FamilyCalendarState,
                        ({
                          DateTime selectedDate,
                          CalendarDayEntity? selectedDay,
                          bool isLoadingDay,
                          bool canEdit,
                          String? memberId,
                          String displayName,
                          String? activeSubscriptionId,
                          List<FamilyMemberSummaryEntity> members,
                        })
                      >(
                        selector: (state) {
                          final hasMeals =
                              state.selectedDay?.meals.isNotEmpty == true;
                          final canEdit =
                              (state.selectedDay?.isEditable == true) &&
                              (hasMeals
                                  ? state.canViewCalendar
                                  : state.canEditMealsAndDays);
                          return (
                            selectedDate: state.selectedDate ?? DateTime.now(),
                            selectedDay: state.selectedDay,
                            isLoadingDay: state.isLoadingDay,
                            canEdit: canEdit,
                            memberId:
                                state.currentMember?.memberId ??
                                widget.args?.memberId,
                            displayName: state.displayName,
                            activeSubscriptionId: state.activeSubscriptionId,
                            members: state.members,
                          );
                        },
                        builder: (context, data) {
                          return FamilyMemberSelectedDaySection(
                            selectedDate: data.selectedDate,
                            selectedDay: data.selectedDay,
                            isLoadingDay: data.isLoadingDay,
                            canEdit: data.canEdit,
                            memberId: data.memberId,
                            displayName: data.displayName,
                            onChooseMeals: () {
                              final activeSubId = data.activeSubscriptionId;
                              if (activeSubId == null || activeSubId.isEmpty) {
                                return;
                              }
                              Navigator.of(context).pushNamed(
                                AppRoutes.familyRestaurants,
                                arguments: FamilyRestaurantsArgs(
                                  subscriptionId: activeSubId,
                                  date: data.selectedDate,
                                  memberName: data.displayName,
                                  memberId: data.memberId,
                                  members: data.members,
                                  viewModel: _viewModel,
                                ),
                              );
                            },
                            onShowDetails: () {
                              final activeSubId = data.activeSubscriptionId;
                              if (activeSubId == null || activeSubId.isEmpty) {
                                return;
                              }
                              Navigator.of(context).pushNamed(
                                AppRoutes.familyMemberDayDetails,
                                arguments: FamilyDayMealsArgs(
                                  subscriptionId: activeSubId,
                                  date: data.selectedDate,
                                  memberName: data.displayName,
                                  memberId: data.memberId,
                                  members: data.members,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
