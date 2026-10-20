import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/overview/data/data_source/family_overview_remote_data_source.dart';
import 'package:meal_meat_user/features/family_management/overview/data/mapper/family_overview_mapper.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_home_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/repo/family_overview_repository.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_error_mapper.dart';

@Injectable(as: FamilyOverviewRepository)
class FamilyOverviewRepositoryImpl implements FamilyOverviewRepository {
  const FamilyOverviewRepositoryImpl(this._remoteDataSource);

  final FamilyOverviewRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<FamilyHomeEntity>> getFamilyHome({
    String locale = 'ar',
  }) async {
    try {
      final dto = await _remoteDataSource.getFamilyHome();
      final entity = FamilyOverviewMapper.toHomeEntity(dto, locale: locale);
      return ApiSuccessResult(data: entity);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }

  @override
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getFamilyMembers({
    String locale = 'ar',
  }) {
    return safeApiCall(() async {
      final dtos = await _remoteDataSource.getFamilyMembers();
      return dtos
          .map(
            (d) =>
                FamilyOverviewMapper.toMemberSummaryEntity(d, locale: locale),
          )
          .toList();
    });
  }

  @override
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getFamilySwitcher({
    String locale = 'ar',
  }) async {
    try {
      final dtos = await _remoteDataSource.getFamilySwitcher();
      final entities = dtos
          .map(
            (d) =>
                FamilyOverviewMapper.toMemberSummaryEntity(d, locale: locale),
          )
          .toList();
      return ApiSuccessResult(data: entities);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }
}
