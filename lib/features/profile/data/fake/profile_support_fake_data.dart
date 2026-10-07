import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_content_entity.dart';

abstract final class ProfileSupportFakeData {
  static const List<ProfileSupportFaqItemEntity> faqItems = [
    ProfileSupportFaqItemEntity(
      id: 'faq_subscription_start',
      question: _faqQ1,
      answer: _faqA1,
    ),
    ProfileSupportFaqItemEntity(
      id: 'faq_meal_changes',
      question: _faqQ2,
      answer: _faqA2,
    ),
    ProfileSupportFaqItemEntity(
      id: 'faq_delivery_address',
      question: _faqQ3,
      answer: _faqA3,
    ),
    ProfileSupportFaqItemEntity(
      id: 'faq_subscription_freeze',
      question: _faqQ4,
      answer: _faqA4,
    ),
    ProfileSupportFaqItemEntity(
      id: 'faq_billing_invoices',
      question: _faqQ5,
      answer: _faqA5,
    ),
    ProfileSupportFaqItemEntity(
      id: 'faq_dietary_allergies',
      question: _faqQ6,
      answer: _faqA6,
    ),
    ProfileSupportFaqItemEntity(
      id: 'faq_renewal',
      question: _faqQ7,
      answer: _faqA7,
    ),
    ProfileSupportFaqItemEntity(
      id: 'faq_customer_support',
      question: _faqQ8,
      answer: _faqA8,
    ),
  ];

  static List<({String id, String Function(AppLocalizations) label})>
  complaintCategories = [
    (
      id: 'delivery',
      label: (AppLocalizations l) => l.profile_support_category_delivery,
    ),
    (
      id: 'meals',
      label: (AppLocalizations l) => l.profile_support_category_meals,
    ),
    (
      id: 'payment',
      label: (AppLocalizations l) => l.profile_support_category_payment,
    ),
    (
      id: 'other',
      label: (AppLocalizations l) => l.profile_support_category_other,
    ),
  ];

  static String _faqQ1(AppLocalizations l) => l.profile_faq_q1;
  static String _faqA1(AppLocalizations l) => l.profile_faq_a1;
  static String _faqQ2(AppLocalizations l) => l.profile_faq_q2;
  static String _faqA2(AppLocalizations l) => l.profile_faq_a2;
  static String _faqQ3(AppLocalizations l) => l.profile_faq_q3;
  static String _faqA3(AppLocalizations l) => l.profile_faq_a3;
  static String _faqQ4(AppLocalizations l) => l.profile_faq_q4;
  static String _faqA4(AppLocalizations l) => l.profile_faq_a4;
  static String _faqQ5(AppLocalizations l) => l.profile_faq_q5;
  static String _faqA5(AppLocalizations l) => l.profile_faq_a5;
  static String _faqQ6(AppLocalizations l) => l.profile_faq_q6;
  static String _faqA6(AppLocalizations l) => l.profile_faq_a6;
  static String _faqQ7(AppLocalizations l) => l.profile_faq_q7;
  static String _faqA7(AppLocalizations l) => l.profile_faq_a7;
  static String _faqQ8(AppLocalizations l) => l.profile_faq_q8;
  static String _faqA8(AppLocalizations l) => l.profile_faq_a8;
}
