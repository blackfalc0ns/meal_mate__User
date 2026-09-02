import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/subscription_packages/data/data_source/subscription_packages_remote_data_source.dart';
import 'package:meal_meat_user/core/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';

@Injectable(as: SubscriptionPackagesRemoteDataSource)
class SubscriptionPackagesRemoteDataSourceImpl
    implements SubscriptionPackagesRemoteDataSource {
  SubscriptionPackagesRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<SubscriptionProgramBundlesResponseDto> getSubscriptionProgramBundles(
    String programId,
  ) {
    return _apiServices.getSubscriptionProgramBundles(programId);
  }
}
