import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_package_days/data/data_source/family_package_days_remote_data_source.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_package_days/domain/repo/family_package_days_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/mapper/family_subscription_setup_mapper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/monthly_plans/data/mapper/subscription_duration_mapper.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/mapper/subscription_tier_mapper.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';

@Injectable(as: FamilyPackageDaysRepository)
class FamilyPackageDaysRepositoryImpl implements FamilyPackageDaysRepository {
  FamilyPackageDaysRepositoryImpl(this._remoteDataSource, this._snapshotStore);

  final FamilyPackageDaysRemoteDataSource _remoteDataSource;
  final FamilyFlowSnapshotStore _snapshotStore;

  @override
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required bool includeFriday,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getDurations(
        programId: programId,
        includeFriday: includeFriday,
      );
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getTiers(
        programId: programId,
        bundleId: bundleId,
        durationDays: durationDays,
        includeFriday: includeFriday,
        familyMemberId: familyMemberId,
      );
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> saveFamilyMemberPlan({
    required String memberId,
    bool clearPlan = false,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
    String? startDate,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.saveFamilyMemberPlan(
        memberId,
        clearPlan
            ? const FamilyMemberPlanWriteRequestDto.clear()
            : FamilyMemberPlanWriteRequestDto(
                programId: programId,
                bundleId: bundleId,
                tier: tier,
                durationDays: durationDays,
                includeFriday: includeFriday,
                startDate: startDate,
              ),
      );
      final entity = response.toEntity();
      _snapshotStore.update(entity);
      return entity;
    });
  }
}
