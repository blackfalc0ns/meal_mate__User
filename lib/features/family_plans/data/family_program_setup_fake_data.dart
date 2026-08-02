import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class FamilyProgramSetupFakeDataSource {
  const FamilyProgramSetupFakeDataSource();

  List<FamilyProgramSetupMemberFakeData> getMembers(AppLocalizations locale) {
    return [
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_mariam,
        imageAsset: AssetsFake.familyMemberMariam,
        status: locale.family_member_not_started,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_yousef,
        imageAsset: AssetsFake.familyMemberYousef,
        status: locale.family_member_not_started,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_sarah,
        imageAsset: AssetsFake.familyMemberSarah,
        status: locale.family_member_not_started,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_ahmed,
        imageAsset: AssetsFake.familyMemberAhmed,
        status: locale.family_member_in_progress,
        isSelected: true,
        isInProgress: true,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_laila,
        imageAsset: AssetsFake.familyMemberSarah,
        status: locale.family_member_not_started,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_omar,
        imageAsset: AssetsFake.familyMemberYousef,
        status: locale.family_member_not_started,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_hana,
        imageAsset: AssetsFake.familyMemberMariam,
        status: locale.family_member_not_started,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_khaled,
        imageAsset: AssetsFake.familyMemberAhmed,
        status: locale.family_member_not_started,
      ),
    ];
  }

  List<FamilyProgramSetupProgramFakeData> getPrograms(AppLocalizations locale) {
    return [
      FamilyProgramSetupProgramFakeData(
        title: locale.family_program_balanced_title,
        description: locale.family_program_balanced_description,
        imageAsset: AssetsFake.familySetupProgramBalanced,
        isSelected: true,
      ),
      FamilyProgramSetupProgramFakeData(
        title: locale.family_program_weight_loss_title,
        description: locale.family_program_weight_loss_description,
        imageAsset: AssetsFake.familySetupProgramWeightLoss,
      ),
      FamilyProgramSetupProgramFakeData(
        title: locale.family_program_muscle_title,
        description: locale.family_program_muscle_description,
        imageAsset: AssetsFake.familySetupProgramMuscle,
      ),
      FamilyProgramSetupProgramFakeData(
        title: locale.family_program_keto_title,
        description: locale.family_program_keto_description,
        imageAsset: AssetsFake.familySetupProgramKeto,
      ),
    ];
  }
}

class FamilyProgramSetupMemberFakeData {
  const FamilyProgramSetupMemberFakeData({
    required this.name,
    required this.imageAsset,
    required this.status,
    this.isSelected = false,
    this.isInProgress = false,
  });

  final String name;
  final String imageAsset;
  final String status;
  final bool isSelected;
  final bool isInProgress;
}

class FamilyProgramSetupProgramFakeData {
  const FamilyProgramSetupProgramFakeData({
    required this.title,
    required this.description,
    required this.imageAsset,
    this.isSelected = false,
  });

  final String title;
  final String description;
  final String imageAsset;
  final bool isSelected;
}
