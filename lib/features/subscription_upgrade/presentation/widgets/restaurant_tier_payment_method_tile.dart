import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_payment_method_logo.dart';

class RestaurantTierPaymentMethodTile extends StatelessWidget {
  const RestaurantTierPaymentMethodTile({
    super.key,
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
  });

  final SubscriptionUpgradePaymentMethodEntity paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: paymentMethod.isAvailable,
      label: paymentMethod.title,
      child: GestureDetector(
        onTap: paymentMethod.isAvailable ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: Spacing.restaurantTierActionPanelHeight,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? color.primaryContainer.withValues(alpha: 0.28)
                : color.surface,
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
              width: isSelected ? Spacing.border : Spacing.hairline,
            ),
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
          ),
          child: Row(
            children: [
              RestaurantTierPaymentMethodLogo(paymentMethod: paymentMethod),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: paymentMethod.isAvailable
                            ? color.onSurface
                            : color.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _subtitle(locale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected ? color.primary : color.outline,
                size: Spacing.iconMd,
                semanticLabel: locale.profile_billing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(dynamic locale) {
    final rawCurrency = paymentMethod.currencyCode;
    final currencyText =
        (rawCurrency.isEmpty || rawCurrency.toUpperCase() == 'KWD')
            ? locale.currency
            : rawCurrency;
    if (paymentMethod.serviceCharge > 0) {
      return '${paymentMethod.serviceCharge.toStringAsFixed(2)} $currencyText';
    }
    return paymentMethod.integrationType;
  }
}
