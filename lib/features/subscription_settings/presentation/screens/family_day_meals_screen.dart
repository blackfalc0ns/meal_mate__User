import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_day_details_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_header.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_meal_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_selected_status.dart';

class FamilyDayMealsScreen extends StatefulWidget {
  const FamilyDayMealsScreen({super.key});

  @override
  State<FamilyDayMealsScreen> createState() => _FamilyDayMealsScreenState();
}

class _FamilyDayMealsScreenState extends State<FamilyDayMealsScreen> {
  static const _dataSource = FamilyDayDetailsFakeDataSource();

  DateTime _selectedDate = DateTime(2024, 5, 26);
  int _selectedMemberIndex = 3;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final details = _dataSource.getDetails();
    final safeSelectedMemberIndex = details.members.isEmpty
        ? 0
        : _selectedMemberIndex.clamp(0, details.members.length - 1).toInt();
    final selectedMember = details.members.isEmpty
        ? details.member
        : details.members[safeSelectedMemberIndex];

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
                FamilyDayMemberSelector(
                  members: details.members,
                  selectedIndex: safeSelectedMemberIndex,
                  onMemberSelected: (index) {
                    setState(() => _selectedMemberIndex = index);
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
                for (final meal in details.meals) ...[
                  FamilyDayMealCard(
                    meal: meal,
                    onEditPressed: _openRestaurants,
                  ),
                  const SizedBox(height: Spacing.familyDayMealListGap),
                ],
                const SizedBox(height: Spacing.familyDayReviewButtonTopGap),
                FamilyDayReviewButton(
                  label: details.reviewButtonLabel,
                  onPressed: () {
                    context.pushNamed(AppRoutes.familyReviewMemberMeals);
                  },
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

  void _openRestaurants() {
    context.pushNamed(AppRoutes.familyRestaurants);
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = context.localization;
    return DateFormat.yMMMMEEEEd(locale.localeName).format(date);
  }
}
