import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_package_days/data/data_source/family_package_days_remote_data_source.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_package_days/domain/repo/family_package_days_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/mapper/family_subscription_setup_mapper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

@Injectable(as: FamilyPackageDaysRepository)
class FamilyPackageDaysRepositoryImpl implements FamilyPackageDaysRepository {
  FamilyPackageDaysRepositoryImpl(this._remoteDataSource);

  final FamilyPackageDaysRemoteDataSource _remoteDataSource;

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
}
