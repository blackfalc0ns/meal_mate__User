import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_types/data/data_source/subscription_types_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_types/data/mapper/subscription_conversion_options_mapper.dart';
import 'package:meal_meat_user/features/subscription_types/data/mapper/subscription_type_mapper.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_types/domain/repo/subscription_types_repository.dart';

@Injectable(as: SubscriptionTypesRepository)
class SubscriptionTypesRepositoryImpl implements SubscriptionTypesRepository {
  SubscriptionTypesRepositoryImpl(this._remoteDataSource);

  final SubscriptionTypesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<SubscriptionTypeEntity>>> getSubscriptionTypes() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSubscriptionTypes();
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<ConversionOptionsModel>> getSubscriptionConversionOptions() {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getSubscriptionConversionOptions();
      return response.toEntity();
    });
  }
}
