import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/data/calendar_fake_data_source.dart';

part 'calendar_sheet_handle.dart';
part 'calendar_meal_picker_restaurant_header.dart';
part 'calendar_meal_picker_restaurant_description.dart';
part 'calendar_source_section.dart';
part 'calendar_source_card.dart';
part 'calendar_meal_tabs.dart';
part 'calendar_tab_label.dart';
part 'calendar_meal_options_section.dart';
part 'calendar_section_title.dart';
part 'calendar_meal_option_card.dart';
part 'calendar_select_button.dart';
part 'calendar_meal_nutrition_row.dart';
part 'calendar_meal_nutrition.dart';
part 'calendar_meal_ingredient_row.dart';
part 'calendar_meal_picker_ingredient_chip.dart';
part 'calendar_divider_line.dart';
part 'calendar_protein_logo.dart';

class CalendarMealPickerSheet extends StatefulWidget {
  const CalendarMealPickerSheet({super.key});

  @override
  State<CalendarMealPickerSheet> createState() =>
      CalendarMealPickerSheetState();
}

class CalendarMealPickerSheetState extends State<CalendarMealPickerSheet> {
  static const _dataSource = CalendarFakeDataSource();

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final height = MediaQuery.sizeOf(context).height;

    final mealTabs = [
      locale.calendar_breakfast,
      locale.calendar_lunch,
      locale.calendar_dinner,
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: height,
        color: color.surface,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 221,
              child: Image.asset(
                Assets.calendarMealPickerHero,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 63,
              right: 24,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                color: color.onSurface,
                iconSize: 24,
              ),
            ),
            Positioned(
              top: 189,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(31.2),
                ),
                child: ColoredBox(
                  color: color.surface,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: Spacing.lg),
                            const CalendarSheetHandle(),
                            const SizedBox(height: Spacing.xl),
                            const CalendarMealPickerRestaurantHeader(),
                            const SizedBox(height: Spacing.lg),
                            const CalendarMealPickerRestaurantDescription(),
                            const SizedBox(height: 21),
                            const CalendarSourceSection(),
                            const SizedBox(height: Spacing.base),
                            CalendarMealTabs(
                              labels: mealTabs,
                              selectedIndex: _selectedTab,
                              onChanged: (index) {
                                setState(() => _selectedTab = index);
                              },
                            ),
                            const SizedBox(height: Spacing.xl),
                            CalendarMealOptionsSection(
                              mealType: mealTabs[_selectedTab],
                              tabIndex: _selectedTab,
                              options: _dataSource.getMealPickerOptions(
                                locale: locale,
                                selectedTab: _selectedTab,
                              ),
                            ),
                            const SizedBox(height: Spacing.xxl),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
