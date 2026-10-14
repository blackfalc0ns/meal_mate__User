import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_home_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_summary_response_dto.dart';

abstract interface class FamilyOverviewRemoteDataSource {
  Future<FamilyHomeResponseDto> getFamilyHome();
  Future<List<FamilyMemberSummaryResponseDto>> getFamilyMembers();
  Future<List<FamilyMemberSummaryResponseDto>> getFamilySwitcher();
}
