import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

abstract class FamilyPackageDaysRepository {
  Future<ApiResult<FamilyFlowCurrentEntity>> saveFamilyMemberPlan({
    required String memberId,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
    String? startDate,
  });
}
