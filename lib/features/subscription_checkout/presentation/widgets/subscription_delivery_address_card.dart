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

    final primaryLine = address?.addressLine.trim().isNotEmpty == true
        ? address!.addressLine
        : address?.label ?? '';

    final secondaryLine = address?.formattedAddress;

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
                  locale.subscription_address_title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size15,
                    color: color.onSurface,
                  ),
                ),
                if (primaryLine.isNotEmpty) ...[
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    primaryLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
                if (secondaryLine != null &&
                    secondaryLine.isNotEmpty &&
                    secondaryLine != primaryLine) ...[
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    secondaryLine,
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
