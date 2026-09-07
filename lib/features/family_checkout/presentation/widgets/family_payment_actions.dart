import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyPaymentActions extends StatelessWidget {
  const FamilyPaymentActions({
    super.key,
    this.canCheckout = true,
    this.isLoading = false,
    this.checkoutBlockReason,
    this.onConfirmPayment,
    this.onResolveBlocker,
  });

  final bool canCheckout;
  final bool isLoading;
  final String? checkoutBlockReason;
  final VoidCallback? onConfirmPayment;
  final VoidCallback? onResolveBlocker;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!canCheckout &&
            checkoutBlockReason != null &&
            checkoutBlockReason!.isNotEmpty) ...[
          InkWell(
            onTap: onResolveBlocker,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              margin: const EdgeInsets.only(bottom: Spacing.sm),
              decoration: BoxDecoration(
                color: color.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                border: Border.all(color: color.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: color.error,
                    size: Spacing.iconSm,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Text(
                      checkoutBlockReason!,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        Row(
          children: [
            SizedBox(
              width: Spacing.familyProgramPreviousButtonWidth,
              child: AppButton.outlined(
                text: locale.family_previous_program,
                onPressed: () => Navigator.maybePop(context),
                height: Spacing.familySetupBottomButtonHeight,
                borderRadius: Spacing.radiusPill,
                color: color.primary,
                textColor: color.primary,
                fontSize: FontSize.size10,
                iconWidget: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: color.primary,
                  size: Spacing.iconSm,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: Spacing.familyProgramNextButtonWidth,
              child: AppButton.filled(
                text: locale.family_confirm_payment,
                onPressed: canCheckout && !isLoading ? onConfirmPayment : null,
                height: Spacing.familySetupBottomButtonHeight,
                borderRadius: Spacing.radiusPill,
                textColor: color.onPrimary,
                fontSize: FontSize.size12,
                iconWidget: Icon(
                  Icons.credit_card_rounded,
                  color: color.onPrimary,
                  size: Spacing.iconSm,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
