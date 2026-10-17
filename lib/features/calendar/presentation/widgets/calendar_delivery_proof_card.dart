import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryProofCard extends StatelessWidget {
  const CalendarDeliveryProofCard({
    super.key,
    required this.deliveryItem,
    required this.onViewPhoto,
  });

  final CustomerDeliveryItemEntity deliveryItem;
  final VoidCallback onViewPhoto;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final photoUrl = deliveryItem.deliveryPhotoUrl;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          child: Container(
            width: double.infinity,
            height: 140,
            color: color.surfaceContainerHighest,
            child: (photoUrl != null && photoUrl.isNotEmpty)
                ? Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Image.asset(
                      Assets.homeDeliveryBox,
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset(
                    Assets.homeDeliveryBox,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppButton.outlined(
          text: locale.calendar_delivery_view_proof_photo,
          onPressed: onViewPhoto,
          iconWidget: Icon(
            Icons.crop_original_rounded,
            color: color.primary,
            size: Spacing.iconSm,
          ),
          iconBeforeText: true,
          color: color.primary,
          textColor: color.primary,
          height: Spacing.buttonSmallHeight,
          borderRadius: Spacing.buttonSmallRadius,
          fontSize: FontSize.size12,
        ),
      ],
    );
  }
}
