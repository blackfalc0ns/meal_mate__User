import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_response_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_metadata_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_plan_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_payment_method_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_summary_entity.dart';

abstract interface class FamilyPlansRepository {
  Future<ApiResult<FamilyMetadataEntity>> getMetadata();

  Future<ApiResult<FamilyGroupEntity>> getCurrentGroup();

  Future<ApiResult<FamilyGroupEntity>> updateGroup(
    FamilyGroupRequestEntity request,
  );

  Future<ApiResult<FamilyGroupEntity>> addMember(
    FamilyMemberRequestEntity request,
  );

  Future<ApiResult<FamilyGroupEntity>> updateMember({
    required String memberId,
    required FamilyMemberRequestEntity request,
  });

  Future<ApiResult<FamilyGroupEntity>> deleteMember(String memberId);

  Future<ApiResult<FamilyGroupEntity>> updateMemberPlan({
    required String memberId,
    required FamilyMemberPlanRequestEntity request,
  });

  Future<ApiResult<FamilySummaryEntity>> getSummary({String? memberId});

  Future<ApiResult<List<FamilyPaymentMethodEntity>>> getPaymentMethods(
    double amount,
  );

  Future<ApiResult<FamilyCheckoutResponseEntity>> checkout(
    FamilyCheckoutRequestEntity request,
  );
}
