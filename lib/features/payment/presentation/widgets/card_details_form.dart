import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// ─────────────────────────────────────────────────────────────
/// Card details form shown when Mada or Visa/Mastercard is
/// selected. Contains card number, expiry, CVV & holder name.
/// ─────────────────────────────────────────────────────────────
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
      child: Container(
        padding: const EdgeInsets.all(Spacing.base),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ── Section title ──
            Text(
              l10n.payment_card_details_title,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.base),

            // ── Card number ──
            _CardTextField(
              controller: cardNumberController,
              hint: l10n.payment_card_number_hint,
              suffixIcon: const Icon(
                Icons.credit_card_rounded,
                color: AppColors.textHint,
                size: 20,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              maxLength: 19,
            ),
            const SizedBox(height: Spacing.md),

            // ── Expiry + CVV row ──
            Row(
              children: [
                // CVV (left in RTL = right visually)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.payment_cvv_label,
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      _CardTextField(
                        controller: cvvController,
                        hint: l10n.payment_cvv_hint,
                        suffixIcon: const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.textHint,
                          size: 18,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 3,
                        obscureText: true,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.md),
                // Expiry
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.payment_expiry_label,
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      _CardTextField(
                        controller: expiryController,
                        hint: l10n.payment_expiry_hint,
                        suffixIcon: const Icon(
                          Icons.calendar_today_rounded,
                          color: AppColors.textHint,
                          size: 18,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _ExpiryFormatter(),
                        ],
                        maxLength: 5,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),

            // ── Holder name ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.payment_card_holder_label,
                  style: getMediumStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                _CardTextField(
                  controller: holderNameController,
                  hint: l10n.payment_card_holder_hint,
                  suffixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Internal field widget ─────────────────────────────────────

class _CardTextField extends StatelessWidget {
  const _CardTextField({
    required this.controller,
    required this.hint,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
    this.textAlign = TextAlign.end,
  });

  final TextEditingController controller;
  final String hint;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscureText;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      textAlign: textAlign,
      style: getMediumStyle(
        fontFamily: FontConstant.ibmPlexSansArabic,
        fontSize: FontSize.size14,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: getRegularStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size13,
          color: AppColors.textHint,
        ),
        suffixIcon: suffixIcon,
        counterText: '',
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.base,
          vertical: Spacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ── Input formatters ──────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
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
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
