import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';

abstract interface class AuthRepository {
  Future<ApiResult<RegisterEntity>> register(RegisterRequestEntity request);
}
