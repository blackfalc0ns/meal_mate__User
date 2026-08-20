import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_packages/data/mapper/subscription_bundle_mapper.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/core/subscription_programs/data/mapper/subscription_program_mapper.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_plans/data/data_source/family_subscription_remote_data_source.dart';
import 'package:meal_meat_user/features/family_plans/data/mapper/family_subscription_mapper.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_group_write_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_subscription_repository.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

@Injectable(as: FamilySubscriptionRepository)
class FamilySubscriptionRepositoryImpl implements FamilySubscriptionRepository {
  FamilySubscriptionRepositoryImpl(this._remoteDataSource);

  final FamilySubscriptionRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<FamilySizePackageEntity>>> getFamilySizePackages() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilySizePackages();
      return response.map((p) => p.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<FamilyRelationshipEntity>>> getFamilyRelationships() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilyRelationships();
      return response.map((r) => r.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> getFamilySubscriptionCurrent() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilySubscriptionCurrent();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> updateFamilyGroup({
    required String name,
    String? familyPackageId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateFamilyGroup(
        FamilyGroupWriteRequestDto(
          name: name,
          familyPackageId: familyPackageId,
        ),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> addFamilyMember({
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addFamilyMember(
        FamilyMemberWriteRequestDto(
          displayName: displayName,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: ageYears,
          deliveryAddressId: deliveryAddressId,
        ),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> updateFamilyMember({
    required String memberId,
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateFamilyMember(
        memberId,
        FamilyMemberWriteRequestDto(
          displayName: displayName,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: ageYears,
          deliveryAddressId: deliveryAddressId,
        ),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> deleteFamilyMember(
    String memberId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.deleteFamilyMember(memberId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<SubscriptionProgramEntity>>> getFamilyPrograms() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilyPrograms();
      return response.map((p) => p.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<SubscriptionBundleEntity>>> getFamilyProgramBundles(
    String programId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilyProgramBundles(
        programId,
      );
      return response.map((b) => b.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> saveFamilyMemberPlan({
    required String memberId,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.saveFamilyMemberPlan(
        memberId,
        FamilyMemberPlanWriteRequestDto(
          programId: programId,
          bundleId: bundleId,
          tier: tier,
          durationDays: durationDays,
          includeFriday: includeFriday,
        ),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilySummaryEntity>> getFamilySummary({String? memberId}) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilySummary(memberId: memberId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> getFamilyPaymentMethods(
    double amount,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilyPaymentMethods(amount);
      return response.map((p) => p.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<PaymentCheckoutEntity>> checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required int paymentMethodId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.checkoutFamilySubscription(
        FamilyCheckoutRequestDto(
          callbackUrl: callbackUrl,
          errorUrl: errorUrl,
          paymentMethodId: paymentMethodId,
        ),
      );
      return response.toEntity();
    });
  }
}
