import 'package:meal_meat_user/core/network/api_results.dart';
import '../entities/eligible_start_dates_entity.dart';

abstract interface class EligibleStartDatesRepository {
  Future<ApiResult<EligibleStartDatesEntity>> getDates({
    required bool includeFriday,
  });
}
