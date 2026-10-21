import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

FamilyDayMemberEntity presentFamilyCalendarMember(
  FamilyMemberSummaryEntity? member,
  AppLocalizations locale, {
  String displayName = '',
  String? memberId,
  String? subscriptionId,
}) => FamilyDayMemberEntity(
  name: member?.displayName ?? displayName,
  ageLabel: member?.ageYears == null
      ? ''
      : locale.family_member_age_years(member!.ageYears!),
  statusLabel: member?.isPaused == true
      ? locale.family_member_paused_label
      : locale.family_member_active_label,
  imageAsset: Assets.profileAvatar,
  memberId: member?.memberId ?? memberId,
  subscriptionId: member?.effectiveSubscriptionId ?? subscriptionId,
);
