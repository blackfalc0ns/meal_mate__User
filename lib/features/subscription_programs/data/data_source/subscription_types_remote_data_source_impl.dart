import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_programs/data/data_source/subscription_types_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_type_response_dto.dart';

@Injectable(as: SubscriptionTypesRemoteDataSource)
class SubscriptionTypesRemoteDataSourceImpl
    implements SubscriptionTypesRemoteDataSource {
  SubscriptionTypesRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<SubscriptionTypeResponseDto>> getSubscriptionTypes() {
    return _apiServices.getSubscriptionTypes();
  }
}
