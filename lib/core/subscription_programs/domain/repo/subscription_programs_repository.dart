import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';

abstract interface class SubscriptionProgramsRepository {
  Future<ApiResult<List<SubscriptionProgramEntity>>> getSubscriptionPrograms();
}
