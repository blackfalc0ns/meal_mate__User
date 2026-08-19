import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/data/data_source/family_plans_remote_data_source.dart';
import 'package:meal_meat_user/features/family_plans/data/mapper/family_plans_mapper.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_response_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_metadata_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_plan_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_payment_method_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_plans_repository.dart';

@Injectable(as: FamilyPlansRepository)
class FamilyPlansRepositoryImpl implements FamilyPlansRepository {
  FamilyPlansRepositoryImpl(this._remoteDataSource);

  final FamilyPlansRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<FamilyMetadataEntity>> getMetadata() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getMetadata();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyGroupEntity>> getCurrentGroup() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCurrentGroup();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyGroupEntity>> updateGroup(
    FamilyGroupRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateGroup(request.toDto());
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyGroupEntity>> addMember(
    FamilyMemberRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addMember(request.toDto());
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyGroupEntity>> updateMember({
    required String memberId,
    required FamilyMemberRequestEntity request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateMember(
        memberId,
        request.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyGroupEntity>> deleteMember(String memberId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.deleteMember(memberId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyGroupEntity>> updateMemberPlan({
    required String memberId,
    required FamilyMemberPlanRequestEntity request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateMemberPlan(
        memberId,
        request.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilySummaryEntity>> getSummary({String? memberId}) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSummary(memberId: memberId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<FamilyPaymentMethodEntity>>> getPaymentMethods(
    double amount,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getPaymentMethods(amount);
      return response.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<FamilyCheckoutResponseEntity>> checkout(
    FamilyCheckoutRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.checkout(request.toDto());
      return response.toEntity();
    });
  }
}
