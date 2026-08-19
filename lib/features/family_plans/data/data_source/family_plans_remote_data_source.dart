import 'package:meal_meat_user/features/family_plans/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_group_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_plan_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_checkout_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_group_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_metadata_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_payment_method_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_summary_response_dto.dart';

abstract interface class FamilyPlansRemoteDataSource {
  Future<FamilyMetadataResponseDto> getMetadata();

  Future<FamilyGroupResponseDto> getCurrentGroup();

  Future<FamilyGroupResponseDto> updateGroup(FamilyGroupRequestDto request);

  Future<FamilyGroupResponseDto> addMember(FamilyMemberRequestDto request);

  Future<FamilyGroupResponseDto> updateMember(
    String memberId,
    FamilyMemberRequestDto request,
  );

  Future<FamilyGroupResponseDto> deleteMember(String memberId);

  Future<FamilyGroupResponseDto> updateMemberPlan(
    String memberId,
    FamilyMemberPlanRequestDto request,
  );

  Future<FamilySummaryResponseDto> getSummary({String? memberId});

  Future<List<FamilyPaymentMethodResponseDto>> getPaymentMethods(double amount);

  Future<FamilyCheckoutResponseDto> checkout(FamilyCheckoutRequestDto request);
}
