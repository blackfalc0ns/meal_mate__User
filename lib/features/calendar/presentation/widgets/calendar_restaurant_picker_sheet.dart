import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
part 'calendar_restaurant_search_field.dart';
part 'calendar_restaurant_option_card.dart';
part 'calendar_arrow_bubble.dart';
part 'calendar_rating.dart';
part 'calendar_restaurant_copy.dart';
part 'calendar_restaurant_picker_logo.dart';
part 'calendar_circle_text_logo.dart';
part 'calendar_image_circle_logo.dart';

class CalendarRestaurantPickerSheet extends StatelessWidget {
  const CalendarRestaurantPickerSheet({
    super.key,
    required this.restaurants,
    required this.onRestaurantSelected,
  });

  final List<CalendarRestaurantOptionEntity> restaurants;
  final ValueChanged<CalendarRestaurantOptionEntity> onRestaurantSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.75,
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: color.outline, width: 0.8),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 11,
              left: 17,
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
            Positioned(
              top: 11,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 31,
                  height: 3,
                  decoration: BoxDecoration(
                    color: color.outline,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
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
            const Positioned(
              top: 87,
              left: 42,
              right: 42,
              child: CalendarRestaurantSearchField(),
            ),
            Positioned(
              top: 149,
              left: 19,
              right: 20,
              bottom: 24,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: restaurants.length,
                separatorBuilder: (_, _) => const SizedBox(height: 9.2),
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return CalendarRestaurantOptionCard(
                    restaurant: restaurant,
                    onTap: () => onRestaurantSelected(restaurant),
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
