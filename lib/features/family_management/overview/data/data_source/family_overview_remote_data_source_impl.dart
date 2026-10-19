import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_management/overview/data/data_source/family_overview_remote_data_source.dart';
import 'package:meal_meat_user/features/family_management/overview/data/models/response/api/family_home_response_dto.dart';
import 'package:meal_meat_user/features/family_management/overview/data/models/response/api/family_member_summary_response_dto.dart';

@Injectable(as: FamilyOverviewRemoteDataSource)
class FamilyOverviewRemoteDataSourceImpl
    implements FamilyOverviewRemoteDataSource {
  const FamilyOverviewRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<FamilyHomeResponseDto> getFamilyHome() => _apiServices.getFamilyHome();

  @override
  Future<List<FamilyMemberSummaryResponseDto>> getFamilyMembers() =>
      _apiServices.getFamilyMembers();

  @override
  Future<List<FamilyMemberSummaryResponseDto>> getFamilySwitcher() =>
      _apiServices.getFamilySwitcher();
}
