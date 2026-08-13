import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

abstract interface class SubscriptionProgramsRepository {
  Future<ApiResult<List<SubscriptionProgramEntity>>> getSubscriptionPrograms();

  Future<ApiResult<List<SubscriptionBundleEntity>>>
  getSubscriptionProgramBundles(String programId);
}
