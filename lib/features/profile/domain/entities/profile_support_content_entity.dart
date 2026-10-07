import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_message_entity.dart';

class ProfileSupportFaqItemEntity {
  const ProfileSupportFaqItemEntity({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String Function(AppLocalizations locale) question;
  final String Function(AppLocalizations locale) answer;
}

class ProfileSupportSubmitResultEntity {
  const ProfileSupportSubmitResultEntity({
    required this.isSuccess,
    required this.messageKind,
    required this.isDemoOnly,
  });

  final bool isSuccess;
  final ProfileSupportMessageKind messageKind;
  final bool isDemoOnly;
}
