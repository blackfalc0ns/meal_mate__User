import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';

class RestaurantTierPaymentMethodLogo extends StatelessWidget {
  const RestaurantTierPaymentMethodLogo({
    super.key,
    required this.paymentMethod,
  });

  final SubscriptionUpgradePaymentMethodEntity paymentMethod;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final imageUrl = paymentMethod.imageUrl;

    return Container(
      width: Spacing.familyPaymentMethodAssetWidth,
      height: Spacing.familyPaymentMethodAssetHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.radiusXs),
      ),
      child: imageUrl == null || imageUrl.isEmpty
          ? Icon(
              Icons.credit_card_rounded,
              color: color.primary,
              size: Spacing.iconSm,
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.credit_card_rounded,
                color: color.primary,
                size: Spacing.iconSm,
              ),
            ),
    );
  }
}
