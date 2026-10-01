import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

enum AppSubscriptionButtonVariant { checkout, next }

class AppSubscriptionButton extends StatelessWidget {
  const AppSubscriptionButton({
    super.key,
    required this.price,
    required this.currency,
    required this.onPressed,
    this.isLoading = false,
  }) : text = null,
       variant = AppSubscriptionButtonVariant.checkout;

  const AppSubscriptionButton.checkout({
    super.key,
    required this.price,
    required this.currency,
    required this.onPressed,
    this.isLoading = false,
  }) : text = null,
       variant = AppSubscriptionButtonVariant.checkout;

  const AppSubscriptionButton.next({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  }) : price = null,
       currency = null,
       variant = AppSubscriptionButtonVariant.next;

  final String? price;
  final String? currency;
  final String? text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppSubscriptionButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == AppSubscriptionButtonVariant.next) {
      return _buildNextButton(context);
    }
    return _buildCheckoutButton(context);
  }

  Widget _buildNextButton(BuildContext context) {
    final color = context.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppButton.filled(
      iconBeforeText: isRtl ? false : true,
      text: text ?? '',
      onPressed: onPressed,
      isLoading: isLoading,
      borderRadius: Spacing.radiusPill,
      textColor: color.onPrimary,
      fontSize: FontSize.size12,
      iconWidget: Icon(
        isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
        color: color.onPrimary,
        size: Spacing.iconMd,
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isEnabled = onPressed != null;
    final hasPrice = (price ?? '').isNotEmpty;
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
            height: Spacing.buttonHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: hasPrice
                  ? Row(
                      children: [
                        Container(
                          width: Spacing.iconLg + Spacing.unit,
                          height: Spacing.iconLg + Spacing.unit,
                          decoration: BoxDecoration(
                            color: color.surface,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Directionality.of(context) == TextDirection.rtl
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            color: color.primary,
                            size: Spacing.iconMd,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          locale.subscription_details_subscribe_now,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size20,
                            color: foregroundColor,
                          ).copyWith(height: 1),
                        ),
                        const Spacer(),
                        Container(
                          width: Spacing.monthlyPlanSubscribeDividerWidth,
                          height: Spacing.monthlyPlanSubscribeDividerHeight,
                          color: foregroundColor.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          price!,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size16,
                            color: foregroundColor,
                          ).copyWith(height: 1),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          currency!,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: foregroundColor,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Container(
                          width: Spacing.avatarSm - Spacing.unit,
                          height: Spacing.avatarSm - Spacing.unit,
                          decoration: BoxDecoration(
                            color: color.surface,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.attach_money_rounded,
                            color: color.primary,
                            size: Spacing.iconSm,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        locale.subscription_details_subscribe_now,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size18,
                          color: foregroundColor,
                        ).copyWith(height: 1),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
