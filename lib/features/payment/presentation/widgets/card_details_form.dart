import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/labeled_card_field.dart';

class CardDetailsForm extends StatelessWidget {
  const CardDetailsForm({
    super.key,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.holderNameController,
  });

  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final TextEditingController holderNameController;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final l10n = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.payment_card_details_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          LabeledCardField(
            label: l10n.payment_card_number_label,
            child: AppTextField(
              controller: cardNumberController,
              hint: l10n.payment_card_number_hint,
              suffixIcon: Icon(
                Icons.credit_card_outlined,
                color: color.onSurfaceVariant,
                size: Spacing.iconSm + Spacing.unit,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                const CardNumberInputFormatter(),
                LengthLimitingTextInputFormatter(19),
              ],
              textAlign: TextAlign.start,
              fillColor: color.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.base,
                vertical: Spacing.base - Spacing.hairline,
              ),
              borderColor: color.outlineVariant,
              borderRadius: Spacing.inputRadius,
              textStyle: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Expanded(
                child: LabeledCardField(
                  label: l10n.payment_expiry_label,
                  child: AppTextField(
                    controller: expiryController,
                    hint: l10n.payment_expiry_hint,
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: color.onSurfaceVariant,
                      size: Spacing.iconSm + Spacing.xxs,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      const CardExpiryInputFormatter(),
                      LengthLimitingTextInputFormatter(5),
                    ],
                    textAlign: TextAlign.start,
                    fillColor: color.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                      vertical: Spacing.base - Spacing.hairline,
                    ),
                    borderColor: color.outlineVariant,
                    borderRadius: Spacing.inputRadius,
                    textStyle: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: LabeledCardField(
                  label: l10n.payment_cvv_label,
                  child: AppTextField(
                    controller: cvvController,
                    hint: l10n.payment_cvv_hint,
                    suffixIcon: Icon(
                      Icons.help_outline_rounded,
                      color: color.onSurfaceVariant,
                      size: Spacing.iconSm + Spacing.xxs,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    obscureText: true,
                    textAlign: TextAlign.start,
                    fillColor: color.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                      vertical: Spacing.base - Spacing.hairline,
                    ),
                    borderColor: color.outlineVariant,
                    borderRadius: Spacing.inputRadius,
                    textStyle: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          LabeledCardField(
            label: l10n.payment_card_holder_label,
            child: AppTextField(
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: color.onSurfaceVariant,
                size: Spacing.iconSm + Spacing.unit,
              ),
              controller: holderNameController,
              hint: l10n.payment_card_holder_hint,
              keyboardType: TextInputType.name,
              textAlign: TextAlign.start,
              fillColor: color.surface,
              borderColor: color.outlineVariant,
              borderRadius: Spacing.inputRadius,
              textStyle: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  const CardNumberInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CardExpiryInputFormatter extends TextInputFormatter {
  const CardExpiryInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
