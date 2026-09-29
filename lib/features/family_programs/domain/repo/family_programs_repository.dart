import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';

abstract class FamilyProgramsRepository {
  Future<ApiResult<List<SubscriptionProgramEntity>>> getFamilyPrograms({
    int? page,
    int? pageSize,
  });
  Future<ApiResult<List<SubscriptionBundleEntity>>> getFamilyProgramBundles(
    String programId,
  );
}
