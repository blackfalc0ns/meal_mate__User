import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_package_days/data/data_source/family_package_days_remote_data_source.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/core/subscription_duration/data/models/response/subscription_duration_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';

@Injectable(as: FamilyPackageDaysRemoteDataSource)
class FamilyPackageDaysRemoteDataSourceImpl
    implements FamilyPackageDaysRemoteDataSource {
  FamilyPackageDaysRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<SubscriptionDurationResponseDto>> getDurations({
    required String programId,
    required bool includeFriday,
  }) {
    return _apiServices.getFamilySubscriptionDurations(
      programId,
      includeFriday,
    );
  }

  @override
  Future<List<SubscriptionTierResponseDto>> getTiers({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  }) {
    return _apiServices.getFamilySubscriptionTiers(
      programId,
      bundleId,
      durationDays,
      includeFriday,
      familyMemberId,
    );
  }

  @override
  Future<FamilyFlowCurrentResponseDto> saveFamilyMemberPlan(
    String memberId,
    FamilyMemberPlanWriteRequestDto request,
  ) {
    return _apiServices.saveFamilyMemberPlan(memberId, request);
  }
}
