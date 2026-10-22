import 'package:meal_meat_user/core/network/api_results.dart';
import '../entities/compensation_entity.dart';
import '../entities/alternative_date_entity.dart';
import '../entities/compensation_choice_entity.dart';
import '../entities/choose_compensation_request_entity.dart';

abstract interface class CompensationsRepository {
  Future<ApiResult<List<CompensationEntity>>> getCompensations();
  Future<ApiResult<List<AlternativeDateEntity>>> getAlternativeDates(String id);
  Future<ApiResult<CompensationChoiceEntity>> choose(
    ChooseCompensationRequestEntity request,
  );
}
