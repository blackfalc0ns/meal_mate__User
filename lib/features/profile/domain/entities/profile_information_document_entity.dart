import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class ProfileInformationSectionEntity {
  const ProfileInformationSectionEntity({
    required this.id,
    required this.title,
    required this.body,
  });

  final String id;
  final String Function(AppLocalizations locale) title;
  final String Function(AppLocalizations locale) body;
}

class ProfileInformationDocumentEntity {
  const ProfileInformationDocumentEntity({
    required this.id,
    required this.title,
    required this.sections,
    this.lastUpdated,
  });

  final String id;
  final String Function(AppLocalizations locale) title;
  final List<ProfileInformationSectionEntity> sections;
  final String Function(AppLocalizations locale)? lastUpdated;
}
