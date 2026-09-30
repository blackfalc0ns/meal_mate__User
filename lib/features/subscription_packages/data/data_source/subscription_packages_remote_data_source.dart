import 'package:meal_meat_user/features/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';

abstract interface class SubscriptionPackagesRemoteDataSource {
  Future<SubscriptionProgramBundlesResponseDto> getSubscriptionPackages(
    String programId,
  );
}
