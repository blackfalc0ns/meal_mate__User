import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_information_document_entity.dart';

abstract final class ProfileInformationFakeData {
  static const ProfileInformationDocumentEntity privacyPolicyDocument =
      ProfileInformationDocumentEntity(
        id: 'privacy_policy',
        title: _privacyTitle,
        sections: [
          ProfileInformationSectionEntity(
            id: 'sec_privacy_1',
            title: _privSec1Title,
            body: _privSec1Body,
          ),
          ProfileInformationSectionEntity(
            id: 'sec_privacy_2',
            title: _privSec2Title,
            body: _privSec2Body,
          ),
          ProfileInformationSectionEntity(
            id: 'sec_privacy_3',
            title: _privSec3Title,
            body: _privSec3Body,
          ),
          ProfileInformationSectionEntity(
            id: 'sec_privacy_4',
            title: _privSec4Title,
            body: _privSec4Body,
          ),
          ProfileInformationSectionEntity(
            id: 'sec_privacy_5',
            title: _privSec5Title,
            body: _privSec5Body,
          ),
        ],
      );

  static const ProfileInformationDocumentEntity termsDocument =
      ProfileInformationDocumentEntity(
        id: 'terms_and_conditions',
        title: _termsTitle,
        sections: [
          ProfileInformationSectionEntity(
            id: 'sec_terms_1',
            title: _termsSec1Title,
            body: _termsSec1Body,
          ),
          ProfileInformationSectionEntity(
            id: 'sec_terms_2',
            title: _termsSec2Title,
            body: _termsSec2Body,
          ),
          ProfileInformationSectionEntity(
            id: 'sec_terms_3',
            title: _termsSec3Title,
            body: _termsSec3Body,
          ),
          ProfileInformationSectionEntity(
            id: 'sec_terms_4',
            title: _termsSec4Title,
            body: _termsSec4Body,
          ),
          ProfileInformationSectionEntity(
            id: 'sec_terms_5',
            title: _termsSec5Title,
            body: _termsSec5Body,
          ),
        ],
      );

  static String _privacyTitle(AppLocalizations l) =>
      l.profile_settings_privacy_policy;
  static String _privSec1Title(AppLocalizations l) =>
      l.profile_privacy_section1_title;
  static String _privSec1Body(AppLocalizations l) =>
      l.profile_privacy_section1_body;
  static String _privSec2Title(AppLocalizations l) =>
      l.profile_privacy_section2_title;
  static String _privSec2Body(AppLocalizations l) =>
      l.profile_privacy_section2_body;
  static String _privSec3Title(AppLocalizations l) =>
      l.profile_privacy_section3_title;
  static String _privSec3Body(AppLocalizations l) =>
      l.profile_privacy_section3_body;
  static String _privSec4Title(AppLocalizations l) =>
      l.profile_privacy_section4_title;
  static String _privSec4Body(AppLocalizations l) =>
      l.profile_privacy_section4_body;
  static String _privSec5Title(AppLocalizations l) =>
      l.profile_privacy_section5_title;
  static String _privSec5Body(AppLocalizations l) =>
      l.profile_privacy_section5_body;

  static String _termsTitle(AppLocalizations l) => l.profile_settings_terms;
  static String _termsSec1Title(AppLocalizations l) =>
      l.profile_terms_section1_title;
  static String _termsSec1Body(AppLocalizations l) =>
      l.profile_terms_section1_body;
  static String _termsSec2Title(AppLocalizations l) =>
      l.profile_terms_section2_title;
  static String _termsSec2Body(AppLocalizations l) =>
      l.profile_terms_section2_body;
  static String _termsSec3Title(AppLocalizations l) =>
      l.profile_terms_section3_title;
  static String _termsSec3Body(AppLocalizations l) =>
      l.profile_terms_section3_body;
  static String _termsSec4Title(AppLocalizations l) =>
      l.profile_terms_section4_title;
  static String _termsSec4Body(AppLocalizations l) =>
      l.profile_terms_section4_body;
  static String _termsSec5Title(AppLocalizations l) =>
      l.profile_terms_section5_title;
  static String _termsSec5Body(AppLocalizations l) =>
      l.profile_terms_section5_body;
}
