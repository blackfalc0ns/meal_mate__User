import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

class SubscriptionDeliveryAddressCard extends StatelessWidget {
  const SubscriptionDeliveryAddressCard({super.key, required this.address});

  final SubscriptionSummaryAddressEntity? address;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final hasCustomLabel = address?.label.trim().isNotEmpty == true &&
        address!.label.trim() != address?.addressLine.trim();

    final title = hasCustomLabel
        ? address!.label.trim()
        : locale.subscription_address_title;

    final detailLine = address?.addressLine.trim().isNotEmpty == true
        ? address!.addressLine.trim()
        : (address?.formattedAddress ?? '');

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: Spacing.avatarSm,
            height: Spacing.avatarSm,
            decoration: BoxDecoration(
              color: color.primaryContainer,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.location_on_rounded,
              color: color.primary,
              size: Spacing.iconSm,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size15,
                    color: color.onSurface,
                  ),
                ),
                if (detailLine.isNotEmpty) ...[
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    detailLine,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
