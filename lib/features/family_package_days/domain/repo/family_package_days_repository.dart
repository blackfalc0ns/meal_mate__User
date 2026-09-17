import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

abstract class FamilyPackageDaysRepository {
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required bool includeFriday,
  });

  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  });

  Future<ApiResult<FamilyFlowCurrentEntity>> saveFamilyMemberPlan({
    required String memberId,
    bool clearPlan = false,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
    String? startDate,
  });
}
