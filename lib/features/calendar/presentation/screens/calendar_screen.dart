import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_filter_strip.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/presentation/models/calendar_meal_item.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_days_strip.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_timeline_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_progress_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_quick_actions.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedPeriod = 2;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final meals = _buildMeals(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(
              showBackButton: false,
              title: l10n.calendar_title,
            ),
          ),
          SliverToBoxAdapter(
            child: CalendarDaysStrip(
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),
          ),
          const SliverToBoxAdapter(child: CalendarProgressCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(child: CalendarQuickActions()),
          SliverToBoxAdapter(child: _buildPeriodFilter(context)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _CalendarPlanHeader(selectedDate: _selectedDate),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.only(start: 36, end: 20),
            sliver: SliverList.separated(
              itemCount: meals.length,
              separatorBuilder: (_, _) => const SizedBox(height: 18),
              itemBuilder: (_, index) =>
                  CalendarMealTimelineCard(meal: meals[index]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter(BuildContext context) {
    final l10n = context.localization;
    return AppFilterStrip(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 10),
      items: [
        AppFilterItem(
          label: l10n.calendar_full_plan,

          isSelected: _selectedPeriod == 0,
        ),
        AppFilterItem(
          label: l10n.calendar_week,

          isSelected: _selectedPeriod == 1,
        ),
        AppFilterItem(
          label: l10n.calendar_today,

          isSelected: _selectedPeriod == 2,
        ),
        AppFilterItem(
          label: l10n.calendar_week,

          isSelected: _selectedPeriod == 3,
        ),
      ],
      onTap: (index) => setState(() => _selectedPeriod = index),
    );
  }

  List<CalendarMealItem> _buildMeals(BuildContext context) {
    final l10n = context.localization;
    return [
      CalendarMealItem(
        time: l10n.calendar_breakfast_time,
        title: l10n.calendar_breakfast_meal,
        calories: l10n.calendar_breakfast_calories,
        asset: Assets.calendarBreakfast,
        state: CalendarMealState.completed,
      ),
      CalendarMealItem(
        time: l10n.calendar_lunch_time,
        title: l10n.calendar_lunch_meal,
        calories: l10n.calendar_lunch_calories,
        asset: Assets.calendarLunch,
        state: CalendarMealState.current,
        extra: l10n.calendar_lunch_protein,
      ),
      CalendarMealItem(
        time: l10n.calendar_dinner_time,
        title: l10n.calendar_dinner_meal,
        calories: l10n.calendar_dinner_calories,
        asset: Assets.calendarDinner,
        state: CalendarMealState.upcoming,
      ),
      CalendarMealItem(
        time: l10n.calendar_snack_time,
        title: l10n.calendar_snack_meal,
        calories: l10n.calendar_snack_calories,
        asset: Assets.calendarSnack,
        state: CalendarMealState.upcoming,
      ),
    ];
  }
}

class _CalendarPlanHeader extends StatelessWidget {
  const _CalendarPlanHeader({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.calendar_day_plan_date(
            MaterialLocalizations.of(context).formatMediumDate(selectedDate),
          ),
          textAlign: TextAlign.start,
          style: getBoldStyle(
            fontSize: 28,
            fontFamily: FontConstant.ibmPlexSansArabic,
          ),
        ),
        Text(
          l10n.calendar_scheduled_count,
          style: getRegularStyle(
            fontSize: 16,
            fontFamily: FontConstant.ibmPlexSansArabic,
            color: AppColors.calendarTextMuted,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
