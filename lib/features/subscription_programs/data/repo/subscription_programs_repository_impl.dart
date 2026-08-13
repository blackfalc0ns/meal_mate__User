import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/data/data_source/subscription_programs_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_programs/data/mapper/subscription_bundle_mapper.dart';
import 'package:meal_meat_user/features/subscription_programs/data/mapper/subscription_program_mapper.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/repo/subscription_programs_repository.dart';

@Injectable(as: SubscriptionProgramsRepository)
class SubscriptionProgramsRepositoryImpl
    implements SubscriptionProgramsRepository {
  SubscriptionProgramsRepositoryImpl(this._remoteDataSource);

  final SubscriptionProgramsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<SubscriptionProgramEntity>>> getSubscriptionPrograms() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSubscriptionPrograms();
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<SubscriptionBundleEntity>>>
  getSubscriptionProgramBundles(String programId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSubscriptionProgramBundles(
        programId,
      );
      return response.map((item) => item.toEntity()).toList();
    });
  }
}
