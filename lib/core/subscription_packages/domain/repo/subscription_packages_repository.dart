import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_packages/domain/entities/subscription_bundle_entity.dart';

abstract interface class SubscriptionPackagesRepository {
  Future<ApiResult<List<SubscriptionBundleEntity>>> getSubscriptionPackages(
    String programId,
  );
}
