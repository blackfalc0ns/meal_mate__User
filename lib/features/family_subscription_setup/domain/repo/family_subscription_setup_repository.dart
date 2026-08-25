import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';

abstract class FamilySubscriptionSetupRepository {
  Future<ApiResult<List<FamilyRelationshipEntity>>> getFamilyRelationships();
  Future<ApiResult<FamilyFlowCurrentEntity>> getFamilySubscriptionCurrent();
  Future<ApiResult<FamilyFlowCurrentEntity>> convertFromIndividual({
    String? name,
    String? familyPackageId,
  });
  Future<ApiResult<void>> abandonFamilyDraft();
  Future<ApiResult<FamilyFlowCurrentEntity>> updateFamilyGroup({
    required String name,
    String? familyPackageId,
  });
  Future<ApiResult<FamilyFlowCurrentEntity>> addFamilyMember({
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  });
  Future<ApiResult<FamilyFlowCurrentEntity>> updateFamilyMember({
    required String memberId,
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  });
  Future<ApiResult<FamilyFlowCurrentEntity>> deleteFamilyMember(
    String memberId,
  );
}
