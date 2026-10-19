import 'package:meal_meat_user/features/family_management/overview/data/models/response/api/family_home_response_dto.dart';
import 'package:meal_meat_user/features/family_management/overview/data/models/response/api/family_member_summary_response_dto.dart';

abstract interface class FamilyOverviewRemoteDataSource {
  Future<FamilyHomeResponseDto> getFamilyHome();
  Future<List<FamilyMemberSummaryResponseDto>> getFamilyMembers();
  Future<List<FamilyMemberSummaryResponseDto>> getFamilySwitcher();
}
