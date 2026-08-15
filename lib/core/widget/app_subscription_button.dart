import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AppSubscriptionButton extends StatelessWidget {
  const AppSubscriptionButton({
    super.key,
    required this.price,
    required this.currency,
    required this.onPressed,
  });

  final String price;
  final String currency;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isEnabled = onPressed != null;
    final hasPrice = price.isNotEmpty;
    final foregroundColor = isEnabled
        ? color.onPrimary
        : color.onSurfaceVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Spacing.monthlyPlanSubscribeRadius),
        color: isEnabled ? null : color.surfaceContainerHighest,
        gradient: isEnabled
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color.primary.withValues(alpha: 0.82), color.primary],
              )
            : null,
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: color.primary.withValues(alpha: 0.22),
                  blurRadius: Spacing.monthlyPlanSubscribeShadowBlur,
                  offset: const Offset(
                    0,
                    Spacing.monthlyPlanSubscribeShadowOffset,
                  ),
                ),
              ]
            : null,
      ),
      child: Material(
        color: color.surface.withValues(alpha: 0),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(
            Spacing.monthlyPlanSubscribeRadius,
          ),
          child: SizedBox(
            height: Spacing.monthlyPlanSubscribeHeight,
            child: hasPrice
                ? Row(
                    children: [
                      const Spacer(flex: 5),
                      Text(
                        locale.subscription_details_subscribe_now,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size22,
                          color: foregroundColor,
                        ).copyWith(height: 1),
                      ),
                      const Spacer(flex: 4),
                      Container(
                        width: Spacing.monthlyPlanSubscribeDividerWidth,
                        height: Spacing.monthlyPlanSubscribeDividerHeight,
                        color: foregroundColor,
                      ),
                      // const Spacer(flex: 3),
                      // Icon(
                      //   Icons.monetization_on_rounded,
                      //   color: foregroundColor,
                      //   size: Spacing.monthlyPlanSubscribeCoinSize,
                      // ),
                      const SizedBox(width: Spacing.sm),
                      Text(
                        price,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: Spacing.monthlyPlanSubscribePriceSize,
                          color: foregroundColor,
                        ).copyWith(height: 1),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        currency,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: Spacing.monthlyPlanSubscribeCurrencySize,
                          color: foregroundColor,
                        ),
                      ),
                      const Spacer(flex: 4),
                    ],
                  )
                : Center(
                    child: Text(
                      locale.subscription_details_subscribe_now,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size22,
                        color: foregroundColor,
                      ).copyWith(height: 1),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
