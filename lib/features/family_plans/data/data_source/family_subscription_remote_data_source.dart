import 'package:meal_meat_user/core/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/core/subscription_programs/data/models/response/subscription_program_response_dto.dart';
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

abstract class FamilySubscriptionRemoteDataSource {
  Future<List<FamilySizePackageResponseDto>> getFamilySizePackages();
  Future<List<FamilyRelationshipResponseDto>> getFamilyRelationships();
  Future<FamilyFlowCurrentResponseDto> getFamilySubscriptionCurrent();
  Future<FamilyFlowCurrentResponseDto> updateFamilyGroup(
    FamilyGroupWriteRequestDto request,
  );
  Future<FamilyFlowCurrentResponseDto> addFamilyMember(
    FamilyMemberWriteRequestDto request,
  );
  Future<FamilyFlowCurrentResponseDto> updateFamilyMember(
    String memberId,
    FamilyMemberWriteRequestDto request,
  );
  Future<FamilyFlowCurrentResponseDto> deleteFamilyMember(String memberId);
  Future<List<SubscriptionProgramResponseDto>> getFamilyPrograms();
  Future<List<SubscriptionBundleResponseDto>> getFamilyProgramBundles(
    String programId,
  );
  Future<FamilyFlowCurrentResponseDto> saveFamilyMemberPlan(
    String memberId,
    FamilyMemberPlanWriteRequestDto request,
  );
  Future<FamilySummaryResponseDto> getFamilySummary({String? memberId});
  Future<List<PaymentMethodResponseDto>> getFamilyPaymentMethods(double amount);
  Future<PaymentCheckoutResponseDto> checkoutFamilySubscription(
    FamilyCheckoutRequestDto request,
  );
}
