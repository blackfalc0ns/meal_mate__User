import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarRestaurantPickCard extends StatelessWidget {
  const CalendarRestaurantPickCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Material(
        color: color.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.primary),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                PositionedDirectional(
                  top: 7,
                  end: 7,
                  child: Container(
                    height: 20,
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_rounded,
                          color: color.primary,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                            style: getRegularStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size11,
                              color: color.primary,
                            ),
                            children: [
                              TextSpan(
                                text: locale.calendar_pick_restaurant_first,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size11,
                                  color: color.primary,
                                ),
                              ),
                              TextSpan(
                                text: locale.calendar_pick_restaurant_second,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size11,
                                  color: color.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.add_rounded,
                  size: 50,
                  color: color.primary.withValues(alpha: 0.95),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
