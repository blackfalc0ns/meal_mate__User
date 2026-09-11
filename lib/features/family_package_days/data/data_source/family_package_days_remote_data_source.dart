import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/core/subscription_duration/data/models/response/subscription_duration_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';

abstract class FamilyPackageDaysRemoteDataSource {
  Future<List<SubscriptionDurationResponseDto>> getDurations({
    required String programId,
    required bool includeFriday,
  });

  Future<List<SubscriptionTierResponseDto>> getTiers({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  });

  Future<FamilyFlowCurrentResponseDto> saveFamilyMemberPlan(
    String memberId,
    FamilyMemberPlanWriteRequestDto request,
  );
}
