import 'package:meal_meat_user/features/family_context/data/models/response/family_context_response_dto.dart';

abstract interface class FamilyContextRemoteDataSource {
  Future<List<FamilyContextResponseDto>> getMyFamilyContexts();
}
