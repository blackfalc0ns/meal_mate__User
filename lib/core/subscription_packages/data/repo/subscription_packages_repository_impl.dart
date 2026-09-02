import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_packages/data/data_source/subscription_packages_remote_data_source.dart';
import 'package:meal_meat_user/core/subscription_packages/data/mapper/subscription_bundle_mapper.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/repo/subscription_packages_repository.dart';

@Injectable(as: SubscriptionPackagesRepository)
class SubscriptionPackagesRepositoryImpl
    implements SubscriptionPackagesRepository {
  SubscriptionPackagesRepositoryImpl(this._remoteDataSource);

  final SubscriptionPackagesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<SubscriptionBundleEntity>>> getSubscriptionPackages(
    String programId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSubscriptionProgramBundles(
        programId,
      );
      return (response.bundles ?? const [])
          .map((item) => item.toEntity())
          .toList();
    });
  }
}
