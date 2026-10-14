import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';

abstract interface class FamilyContextRepository {
  Future<ApiResult<List<FamilyContextEntity>>> getMyFamilyContexts();
}
