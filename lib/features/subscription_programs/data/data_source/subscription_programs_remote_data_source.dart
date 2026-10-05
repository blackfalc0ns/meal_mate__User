import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_programs_page_response_dto.dart';

abstract interface class SubscriptionProgramsRemoteDataSource {
  Future<List<SubscriptionProgramResponseDto>> getSubscriptionPrograms();

  Future<SubscriptionProgramsPageResponseDto> getSubscriptionProgramsPage({
    required int page,
    required int pageSize,
  });

  Future<SubscriptionProgramBundlesResponseDto> getSubscriptionProgramBundles(
    String programId, {
    int? page,
    int? pageSize,
  });
}
