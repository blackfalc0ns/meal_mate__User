import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryTrackButton extends StatelessWidget {
  const CalendarDeliveryTrackButton({
    super.key,
    required this.deliveryItem,
    required this.onPressed,
  });

  final CustomerDeliveryItemEntity deliveryItem;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isTrackable = deliveryItem.canTrack;
    final buttonText = isTrackable
        ? locale.calendar_delivery_track_order
        : locale.calendar_delivery_details_title;

    return AppButton(
      text: buttonText,
      onPressed: onPressed,
      icon: isTrackable
          ? Icons.location_on_rounded
          : Icons.arrow_forward_ios_rounded,
      iconBeforeText: true,
      height: Spacing.buttonSmallHeight,
      borderRadius: Spacing.buttonSmallRadius,
      color: isTrackable ? color.primary : color.surfaceContainerHighest,
      textColor: isTrackable ? color.onPrimary : color.onSurface,
      fontSize: FontSize.size13,
    );
  }
}
