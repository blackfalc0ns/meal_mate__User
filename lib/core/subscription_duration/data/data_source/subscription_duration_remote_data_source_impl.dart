import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/subscription_duration/data/data_source/subscription_duration_remote_data_source.dart';
import 'package:meal_meat_user/core/subscription_duration/data/models/response/subscription_duration_response_dto.dart';

@Injectable(as: SubscriptionDurationRemoteDataSource)
class SubscriptionDurationRemoteDataSourceImpl
    implements SubscriptionDurationRemoteDataSource {
  SubscriptionDurationRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<SubscriptionDurationResponseDto>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) {
    return _apiServices.getSubscriptionDurations(
      programId,
      bundleId,
      includeFriday,
    );
  }
}
