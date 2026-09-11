import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/family_package_days/domain/repo/family_package_days_repository.dart';

@injectable
class GetFamilyPlanTiersUseCase {
  const GetFamilyPlanTiersUseCase(this._repository);

  final FamilyPackageDaysRepository _repository;

  Future<ApiResult<List<SubscriptionTierEntity>>> call({
    required String programId,
    String? bundleId,
    int? durationDays,
    required bool includeFriday,
    required String familyMemberId,
  }) {
    return _repository.getTiers(
      programId: programId,
      bundleId: bundleId,
      durationDays: durationDays,
      includeFriday: includeFriday,
      familyMemberId: familyMemberId,
    );
  }
}
