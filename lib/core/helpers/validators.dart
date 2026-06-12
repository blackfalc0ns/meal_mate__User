import 'package:flutter/material.dart';

import '../helpers/regex.dart';
import '../l10n/translations/app_localizations.dart';

abstract class Validations {
  static String? validateName(BuildContext context, String? name) {
    final normalizedName = name?.trim() ?? '';
    if (normalizedName.isEmpty) {
      return AppLocalizations.of(context)!.name_is_required;
    } else if (!AppRegExp.isNameValid(normalizedName)) {
      return AppLocalizations.of(context)!.name_is_not_valid;
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? email) {
    final localized = AppLocalizations.of(context)!;
    final normalizedEmail = email?.trim() ?? '';

    if (normalizedEmail.isEmpty) {
      return localized.email_is_required;
    }

    if (normalizedEmail.contains(' ')) {
      return _localizedMessage(
        context,
        ar: 'الإيميل ما ينفعش يحتوي مسافات',
        en: 'Email must not contain spaces',
      );
    }

    if (!normalizedEmail.contains('@')) {
      return _localizedMessage(
        context,
        ar: 'الإيميل ناقص @',
        en: 'Email must contain @',
      );
    }

    final emailParts = normalizedEmail.split('@');
    if (emailParts.length != 2) {
      return _localizedMessage(
        context,
        ar: 'الإيميل لازم يحتوي على @ واحدة فقط',
        en: 'Email must contain only one @',
      );
    }

    final localPart = emailParts.first;
    final domainPart = emailParts.last;

    if (localPart.isEmpty) {
      return _localizedMessage(
        context,
        ar: 'لازم تكتب اسم قبل @',
        en: 'Email must contain text before @',
      );
    }

    if (domainPart.isEmpty) {
      return _localizedMessage(
        context,
        ar: 'لازم تكتب اسم النطاق بعد @',
        en: 'Email must contain a domain after @',
      );
    }

    if (!domainPart.contains('.')) {
      return _localizedMessage(
        context,
        ar: 'الإيميل ناقص اسم النطاق مثل .com',
        en: 'Email must contain a domain like .com',
      );
    }

    final domainSections = domainPart.split('.');
    if (domainSections.any((section) => section.isEmpty)) {
      return _localizedMessage(
        context,
        ar: 'اسم النطاق في الإيميل غير مكتمل',
        en: 'Email domain is incomplete',
      );
    }

    final topLevelDomain = domainSections.last;
    if (topLevelDomain.length < 2) {
      return _localizedMessage(
        context,
        ar: 'امتداد الإيميل غير مكتمل',
        en: 'Email extension is incomplete',
      );
    }

    if (!normalizedEmail.endsWith('.com')) {
      return _localizedMessage(
        context,
        ar: 'الإيميل لازم ينتهي بـ .com',
        en: 'Email must end with .com',
      );
    }

    if (!AppRegExp.isEmailValid(normalizedEmail)) {
      return localized.email_is_not_valid;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? password) {
    final normalizedPassword = password?.trim() ?? '';
    if (normalizedPassword.isEmpty) {
      return AppLocalizations.of(context)!.password_is_required;
    }

    if (normalizedPassword.length < 8) {
      return _localizedMessage(
        context,
        ar: 'كلمة المرور لازم تكون 8 أحرف على الأقل',
        en: 'Password must be at least 8 characters',
      );
    }
    if (!RegExp(r'[A-Z]').hasMatch(normalizedPassword)) {
      return _localizedMessage(
        context,
        ar: 'كلمة المرور لازم تحتوي حرف كبير',
        en: 'Password must contain an uppercase letter',
      );
    }
    if (!RegExp(r'[a-z]').hasMatch(normalizedPassword)) {
      return _localizedMessage(
        context,
        ar: 'كلمة المرور لازم تحتوي حرف صغير',
        en: 'Password must contain a lowercase letter',
      );
    }
    if (!RegExp(r'[0-9]').hasMatch(normalizedPassword)) {
      return _localizedMessage(
        context,
        ar: 'كلمة المرور لازم تحتوي رقم',
        en: 'Password must contain a number',
      );
    }
    if (!RegExp(r'[#?!@$%^&*-]').hasMatch(normalizedPassword)) {
      return _localizedMessage(
        context,
        ar: 'كلمة المرور لازم تحتوي رمز خاص مثل #?!@\$%^&*-',
        en: 'Password must contain a special character like #?!@\$%^&*-',
      );
    }

    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? password,
    String? confirmPassword,
  ) {
    final normalizedPassword = password?.trim() ?? '';
    final normalizedConfirmPassword = confirmPassword?.trim() ?? '';

    if (normalizedConfirmPassword.isEmpty) {
      return AppLocalizations.of(context)!.confirm_password_is_required;
    } else if (!AppRegExp.isPasswordValid(normalizedConfirmPassword)) {
      return AppLocalizations.of(context)!.confirm_password_is_not_valid;
    } else if (normalizedPassword != normalizedConfirmPassword) {
      return AppLocalizations.of(
        context,
      )!.password_and_confirm_password_must_be_same;
    }
    return null;
  }

  static String? validatePhoneNumber(
    BuildContext context,
    String? phoneNumber,
  ) {
    final localized = AppLocalizations.of(context)!;
    final normalizedPhoneNumber = phoneNumber?.trim() ?? '';

    if (normalizedPhoneNumber.isEmpty) {
      return localized.phone_number_is_required;
    }

    if (!RegExp(r'^\d+$').hasMatch(normalizedPhoneNumber)) {
      return _localizedMessage(
        context,
        ar: 'رقم الجوال لازم يحتوي أرقام فقط',
        en: 'Phone number must contain digits only',
      );
    }

    if (normalizedPhoneNumber.length != 11) {
      return _localizedMessage(
        context,
        ar: 'رقم الجوال لازم يكون 11 رقم',
        en: 'Phone number must be 11 digits',
      );
    }

    if (!RegExp(r'^01[0125]').hasMatch(normalizedPhoneNumber)) {
      return _localizedMessage(
        context,
        ar: 'رقم الجوال لازم يبدأ بـ 010 أو 011 أو 012 أو 015',
        en: 'Phone number must start with 010, 011, 012, or 015',
      );
    }

    if (!AppRegExp.isPhoneNumberValid(normalizedPhoneNumber)) {
      return localized.phone_number_is_not_valid;
    }
    return null;
  }

  static String? validateRequired(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.this_field_is_required;
    }
    return null;
  }

  static String? validOtp(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.verification_code_required;
    }
    if (value.trim().length < 4) {
      return AppLocalizations.of(context)!.verification_code_invalid;
    }
    return null;
  }

  static String _localizedMessage(
    BuildContext context, {
    required String ar,
    required String en,
  }) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return languageCode == 'ar' ? ar : en;
  }
}
