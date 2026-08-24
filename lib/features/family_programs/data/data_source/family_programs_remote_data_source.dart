import 'package:meal_meat_user/core/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/core/subscription_programs/data/models/response/subscription_program_response_dto.dart';

abstract class FamilyProgramsRemoteDataSource {
  Future<List<SubscriptionProgramResponseDto>> getFamilyPrograms();
  Future<List<SubscriptionBundleResponseDto>> getFamilyProgramBundles(
    String programId,
  );
}
