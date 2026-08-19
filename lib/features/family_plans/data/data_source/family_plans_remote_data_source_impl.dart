import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_plans/data/data_source/family_plans_remote_data_source.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_group_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_plan_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_checkout_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_group_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_metadata_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_payment_method_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_summary_response_dto.dart';

@Injectable(as: FamilyPlansRemoteDataSource)
class FamilyPlansRemoteDataSourceImpl implements FamilyPlansRemoteDataSource {
  FamilyPlansRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<FamilyMetadataResponseDto> getMetadata() {
    return _apiServices.getFamilyMetadata();
  }

  @override
  Future<FamilyGroupResponseDto> getCurrentGroup() {
    return _apiServices.getCurrentFamilyGroup();
  }

  @override
  Future<FamilyGroupResponseDto> updateGroup(FamilyGroupRequestDto request) {
    return _apiServices.updateFamilyGroup(request);
  }

  @override
  Future<FamilyGroupResponseDto> addMember(FamilyMemberRequestDto request) {
    return _apiServices.addFamilyMember(request);
  }

  @override
  Future<FamilyGroupResponseDto> updateMember(
    String memberId,
    FamilyMemberRequestDto request,
  ) {
    return _apiServices.updateFamilyMember(memberId, request);
  }

  @override
  Future<FamilyGroupResponseDto> deleteMember(String memberId) {
    return _apiServices.deleteFamilyMember(memberId);
  }

  @override
  Future<FamilyGroupResponseDto> updateMemberPlan(
    String memberId,
    FamilyMemberPlanRequestDto request,
  ) {
    return _apiServices.updateFamilyMemberPlan(memberId, request);
  }

  @override
  Future<FamilySummaryResponseDto> getSummary({String? memberId}) {
    return _apiServices.getFamilySummary(memberId);
  }

  @override
  Future<List<FamilyPaymentMethodResponseDto>> getPaymentMethods(double amount) {
    return _apiServices.getFamilyPaymentMethods(amount);
  }

  @override
  Future<FamilyCheckoutResponseDto> checkout(FamilyCheckoutRequestDto request) {
    return _apiServices.checkoutFamilySubscription(request);
  }
}
