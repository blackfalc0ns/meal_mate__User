import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';

abstract interface class SubscriptionProgramsRemoteDataSource {
  Future<List<SubscriptionProgramResponseDto>> getSubscriptionPrograms();
}
