import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_programs/data/mapper/subscription_bundle_mapper.dart';
import 'package:meal_meat_user/features/family_programs/data/mapper/subscription_program_mapper.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/family_programs/data/data_source/family_programs_remote_data_source.dart';
import 'package:meal_meat_user/features/family_programs/domain/repo/family_programs_repository.dart';

@Injectable(as: FamilyProgramsRepository)
class FamilyProgramsRepositoryImpl implements FamilyProgramsRepository {
  FamilyProgramsRepositoryImpl(this._remoteDataSource);

  final FamilyProgramsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<SubscriptionProgramEntity>>> getFamilyPrograms({
    int? page,
    int? pageSize,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilyPrograms(
        page: page,
        pageSize: pageSize,
      );
      return response.map((program) => program.toEntity()).toList();
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
      return response.map((bundle) => bundle.toEntity()).toList();
    });
  }
}
