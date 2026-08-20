import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

abstract class FamilySubscriptionRepository {
  Future<ApiResult<List<FamilySizePackageEntity>>> getFamilySizePackages();
  Future<ApiResult<List<FamilyRelationshipEntity>>> getFamilyRelationships();
  Future<ApiResult<FamilyFlowCurrentEntity>> getFamilySubscriptionCurrent();
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
  Future<ApiResult<FamilyFlowCurrentEntity>> deleteFamilyMember(String memberId);
  Future<ApiResult<List<SubscriptionProgramEntity>>> getFamilyPrograms();
  Future<ApiResult<List<SubscriptionBundleEntity>>> getFamilyProgramBundles(
    String programId,
  );
  Future<ApiResult<FamilyFlowCurrentEntity>> saveFamilyMemberPlan({
    required String memberId,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
  });
  Future<ApiResult<FamilySummaryEntity>> getFamilySummary();
  Future<ApiResult<List<PaymentMethodEntity>>> getFamilyPaymentMethods(
    double amount,
  );
  Future<ApiResult<PaymentCheckoutEntity>> checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required int paymentMethodId,
  });
}
