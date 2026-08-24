import 'package:meal_meat_user/features/subscription_types/data/models/response/subscription_type_response_dto.dart';
import 'package:meal_meat_user/features/subscription_types/data/models/response/subscription_conversion_options_response_dto.dart';

abstract interface class SubscriptionTypesRemoteDataSource {
  Future<List<SubscriptionTypeResponseDto>> getSubscriptionTypes();

  Future<SubscriptionConversionOptionsResponseDto>
  getSubscriptionConversionOptions();
}
