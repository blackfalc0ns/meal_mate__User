import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/data_source/family_subscription_setup_remote_data_source.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_group_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_relationship_response_dto.dart';

@Injectable(as: FamilySubscriptionSetupRemoteDataSource)
class FamilySubscriptionSetupRemoteDataSourceImpl
    implements FamilySubscriptionSetupRemoteDataSource {
  FamilySubscriptionSetupRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<FamilyRelationshipResponseDto>> getFamilyRelationships() {
    return _apiServices.getFamilyRelationships();
  }

  @override
  Future<FamilyFlowCurrentResponseDto> getFamilySubscriptionCurrent() {
    return _apiServices.getFamilySubscriptionCurrent();
  }

  @override
  Future<FamilyFlowCurrentResponseDto> updateFamilyGroup(
    FamilyGroupWriteRequestDto request,
  ) {
    return _apiServices.updateFamilyGroup(request);
  }

  @override
  Future<FamilyFlowCurrentResponseDto> addFamilyMember(
    FamilyMemberWriteRequestDto request,
  ) {
    return _apiServices.addFamilyMember(request);
  }

  @override
  Future<FamilyFlowCurrentResponseDto> updateFamilyMember(
    String memberId,
    FamilyMemberWriteRequestDto request,
  ) {
    return _apiServices.updateFamilyMember(memberId, request);
  }

  @override
  Future<FamilyFlowCurrentResponseDto> deleteFamilyMember(String memberId) {
    return _apiServices.deleteFamilyMember(memberId);
  }
}
