import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
part 'calendar_restaurant_search_field.dart';
part 'calendar_restaurant_option_card.dart';
part 'calendar_arrow_bubble.dart';
part 'calendar_rating.dart';
part 'calendar_restaurant_copy.dart';
part 'calendar_restaurant_picker_logo.dart';
part 'calendar_circle_text_logo.dart';
part 'calendar_restaurant_picker_loading_skeleton.dart';

class CalendarRestaurantPickerSheet extends StatefulWidget {
  const CalendarRestaurantPickerSheet({
    super.key,
    required this.restaurants,
    required this.onRestaurantSelected,
    required this.onSearchChanged,
    this.isLoading = false,
  });

  final List<CalendarRestaurantOptionEntity> restaurants;
  final ValueChanged<CalendarRestaurantOptionEntity> onRestaurantSelected;
  final ValueChanged<String> onSearchChanged;
  final bool isLoading;

  @override
  State<CalendarRestaurantPickerSheet> createState() =>
      _CalendarRestaurantPickerSheetState();
}

class _CalendarRestaurantPickerSheetState
    extends State<CalendarRestaurantPickerSheet> {
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: color.outline, width: 0.8),
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              top: 11,
              end: 17,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 25,
                  height: 25,
                ),
                icon: Icon(
                  Icons.cancel_rounded,
                  color: color.outline,
                  size: 25,
                ),
              ),
            ),
            PositionedDirectional(
              top: 11,
              start: 0,
              end: 0,
              child: Center(
                child: SizedBox(
                  width: 31,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color.outline,
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    ),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: 30,
              start: 0,
              end: 0,
              child: Column(
                children: [
                  Text(
                    locale.calendar_browse_restaurants,
                    textAlign: TextAlign.center,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: 14,
                      color: color.onSurface,
                    ).copyWith(height: 20 / 14, letterSpacing: 0),
                  ),
                  const SizedBox(height: Spacing.xs),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: 10,
                        color: color.onSurface.withValues(alpha: 0.64),
                      ).copyWith(height: 2, letterSpacing: 0),
                      children: [
                        TextSpan(
                          text: locale.calendar_choose_restaurant_for_day,
                        ),
                        TextSpan(
                          text: locale.calendar_restaurant_picker_date,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: 10,
                            color: color.tertiary,
                          ).copyWith(height: 2, letterSpacing: 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: 87,
              start: 42,
              end: 42,
              child: CalendarRestaurantSearchField(onChanged: _onSearchChanged),
            ),
            PositionedDirectional(
              top: 149,
              start: 19,
              end: 20,
              bottom: 24,
              child: widget.isLoading
                  ? const CalendarRestaurantPickerLoadingSkeleton()
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: widget.restaurants.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 9.2),
                      itemBuilder: (context, index) {
                        final restaurant = widget.restaurants[index];
                        return CalendarRestaurantOptionCard(
                          restaurant: restaurant,
                          onTap: () => widget.onRestaurantSelected(restaurant),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
