import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_packages/data/data_source/subscription_packages_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_packages/data/mapper/subscription_bundle_mapper.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/repo/subscription_packages_repository.dart';

@Injectable(as: SubscriptionPackagesRepository)
class SubscriptionPackagesRepositoryImpl
    implements SubscriptionPackagesRepository {
  SubscriptionPackagesRepositoryImpl(this._remoteDataSource);

  final SubscriptionPackagesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<SubscriptionProgramBundlesEntity>> getSubscriptionPackages(
    String programId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSubscriptionPackages(
        programId,
      );
      return response.toProgramBundlesEntity();
    });
  }
}
