import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/core/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/data_source/family_subscription_remote_data_source.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_group_write_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_relationship_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_size_package_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';

@Injectable(as: FamilySubscriptionRemoteDataSource)
class FamilySubscriptionRemoteDataSourceImpl
    implements FamilySubscriptionRemoteDataSource {
  FamilySubscriptionRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<FamilySizePackageResponseDto>> getFamilySizePackages() {
    return _apiServices.getFamilySizePackages();
  }

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

  @override
  Future<List<SubscriptionProgramResponseDto>> getFamilyPrograms() {
    return _apiServices.getFamilyPrograms();
  }

  @override
  Future<List<SubscriptionBundleResponseDto>> getFamilyProgramBundles(
    String programId,
  ) {
    return _apiServices.getFamilyProgramBundles(programId);
  }

  @override
  Future<FamilyFlowCurrentResponseDto> saveFamilyMemberPlan(
    String memberId,
    FamilyMemberPlanWriteRequestDto request,
  ) {
    return _apiServices.saveFamilyMemberPlan(memberId, request);
  }

  @override
  Future<FamilySummaryResponseDto> getFamilySummary({String? memberId}) {
    return _apiServices.getFamilySummary(memberId: memberId);
  }

  @override
  Future<List<PaymentMethodResponseDto>> getFamilyPaymentMethods(
    double amount,
  ) {
    return _apiServices.getFamilyPaymentMethods(amount);
  }

  @override
  Future<PaymentCheckoutResponseDto> checkoutFamilySubscription(
    FamilyCheckoutRequestDto request,
  ) {
    return _apiServices.checkoutFamilySubscription(request);
  }
}
