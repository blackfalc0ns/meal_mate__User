import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';

abstract interface class SubscriptionTypesRepository {
  Future<ApiResult<List<SubscriptionTypeEntity>>> getSubscriptionTypes();

  Future<ApiResult<ConversionOptionsModel>> getSubscriptionConversionOptions();
}
