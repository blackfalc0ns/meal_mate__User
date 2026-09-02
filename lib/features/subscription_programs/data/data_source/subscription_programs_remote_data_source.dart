import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';

abstract interface class SubscriptionProgramsRemoteDataSource {
  Future<List<SubscriptionProgramResponseDto>> getSubscriptionPrograms();

  Future<SubscriptionProgramBundlesResponseDto> getSubscriptionProgramBundles(
    String programId,
  );
}
