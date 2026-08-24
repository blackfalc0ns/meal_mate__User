import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_package_days/data/data_source/family_package_days_remote_data_source.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';

@Injectable(as: FamilyPackageDaysRemoteDataSource)
class FamilyPackageDaysRemoteDataSourceImpl
    implements FamilyPackageDaysRemoteDataSource {
  FamilyPackageDaysRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<FamilyFlowCurrentResponseDto> saveFamilyMemberPlan(
    String memberId,
    FamilyMemberPlanWriteRequestDto request,
  ) {
    return _apiServices.saveFamilyMemberPlan(memberId, request);
  }
}
