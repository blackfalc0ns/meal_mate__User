import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/data/family_day_details_fake_data_source.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/family_day_header.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/family_day_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/family_day_member_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/family_day_selected_status.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _dataSource = FamilyDayDetailsFakeDataSource();
  DateTime _selectedDate = DateTime(2024, 5, 26);

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final details = _dataSource.getDetails();

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: Text(
          details.title,
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
          padding: EdgeInsetsDirectional.only(
            start: Spacing.familyDayHorizontalPadding,
            end: Spacing.familyDayHorizontalPadding,
            bottom: widget.showBottomSpace
                ? Spacing.bottomNavHeight + Spacing.xxxl
                : Spacing.xl,
          ),
          child: Semantics(
            label: locale.calendar_title,
            child: Column(
              children: [
                FamilyDayHeader(
                  dateLabel: _formatDate(context, _selectedDate),
                  onPreviousDay: () => _changeDay(-1),
                  onNextDay: () => _changeDay(1),
                  onDatePressed: _openDatePicker,
                ),
                FamilyDayMemberCard(member: details.member),
                const SizedBox(height: Spacing.familyDayMemberTopGap),
                for (final meal in details.meals) ...[
                  FamilyDayMealCard(meal: meal),
                  const SizedBox(height: Spacing.familyDayMealListGap),
                ],
                const SizedBox(height: Spacing.familyDayReviewButtonTopGap),
                FamilyDayReviewButton(
                  label: details.reviewButtonLabel,
                  onPressed: () {},
                ),
                const SizedBox(height: Spacing.familyDaySelectedTopGap),
                FamilyDaySelectedStatus(label: details.selectedMealsLabel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeDay(int days) {
    setState(() {
      _selectedDate = DateUtils.dateOnly(
        _selectedDate.add(Duration(days: days)),
      );
    });
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

    setState(() {
      _selectedDate = DateUtils.dateOnly(pickedDate);
    });
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = context.localization;
    return DateFormat.yMMMMEEEEd(locale.localeName).format(date);
  }
}
