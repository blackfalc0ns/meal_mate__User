import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/data/calendar_fake_data_source.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_day_details_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_header.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_meal_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_selected_status.dart';

class FamilyDayMealsScreen extends StatefulWidget {
  const FamilyDayMealsScreen({super.key});

  @override
  State<FamilyDayMealsScreen> createState() => _FamilyDayMealsScreenState();
}

class _FamilyDayMealsScreenState extends State<FamilyDayMealsScreen> {
  static const _dataSource = FamilyDayDetailsFakeDataSource();
  static const _calendarDataSource = CalendarFakeDataSource();

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
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.familyDayHorizontalPadding,
            end: Spacing.familyDayHorizontalPadding,
            bottom: Spacing.xl,
          ),
          child: Semantics(
            label: details.title,
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
                  FamilyDayMealCard(
                    meal: meal,
                    onEditPressed: _openMealEditFlow,
                  ),
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

  Future<void> _openMealEditFlow() async {
    final selectedRestaurant =
        await showModalBottomSheet<CalendarRestaurantOptionEntity>(
          context: context,
          isScrollControlled: true,
          backgroundColor: context.colorScheme.surface,
          builder: (sheetContext) {
            return CalendarRestaurantPickerSheet(
              restaurants: _calendarDataSource.getRestaurantOptions(),
              onRestaurantSelected: (restaurant) {
                Navigator.pop(sheetContext, restaurant);
              },
            );
          },
        );

    if (selectedRestaurant == null || !mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CalendarMealPickerSheet(
          restaurantName: selectedRestaurant.name,
          restaurantInitials: _restaurantInitials(selectedRestaurant.name),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = context.localization;
    return DateFormat.yMMMMEEEEd(locale.localeName).format(date);
  }

  String _restaurantInitials(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.characters.first)
        .join();
  }
}
