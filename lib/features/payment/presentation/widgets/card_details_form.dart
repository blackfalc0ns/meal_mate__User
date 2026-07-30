import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';

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
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.md),
          _LabeledCardField(
            label: l10n.payment_card_number_label,
            child: AppTextField(
              controller: cardNumberController,
              hint: l10n.payment_card_number_hint,
              suffixIcon: const Icon(
                Icons.credit_card_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
                LengthLimitingTextInputFormatter(19),
              ],
              textAlign: TextAlign.start,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.base,
                vertical: 15,
              ),
              borderColor: AppColors.border,
              borderRadius: Spacing.inputRadius,
              textStyle: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Expanded(
                child: _LabeledCardField(
                  label: l10n.payment_expiry_label,
                  child: AppTextField(
                    controller: expiryController,
                    hint: l10n.payment_expiry_hint,
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _ExpiryFormatter(),
                      LengthLimitingTextInputFormatter(5),
                    ],
                    textAlign: TextAlign.start,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                      vertical: 15,
                    ),
                    borderColor: AppColors.border,
                    borderRadius: Spacing.inputRadius,
                    textStyle: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _LabeledCardField(
                  label: l10n.payment_cvv_label,
                  child: AppTextField(
                    controller: cvvController,
                    hint: l10n.payment_cvv_hint,
                    suffixIcon: const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    obscureText: true,
                    textAlign: TextAlign.start,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                      vertical: 15,
                    ),
                    borderColor: AppColors.border,
                    borderRadius: Spacing.inputRadius,
                    textStyle: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          _LabeledCardField(
            label: l10n.payment_card_holder_label,
            child: AppTextField(
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.textHint,
                size: 20,
              ),
              controller: holderNameController,
              hint: l10n.payment_card_holder_hint,

              keyboardType: TextInputType.name,
              textAlign: TextAlign.start,
              fillColor: AppColors.white,
              // contentPadding: const EdgeInsets.symmetric(
              //   horizontal: Spacing.base,
              //   vertical: 15,
              // ),
              borderColor: AppColors.border,
              borderRadius: Spacing.inputRadius,
              textStyle: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledCardField extends StatelessWidget {
  const _LabeledCardField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        child,
      ],
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
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

class _ExpiryFormatter extends TextInputFormatter {
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
