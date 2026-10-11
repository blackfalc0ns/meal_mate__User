import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/repo/subscription_tier_repository.dart';

@injectable
class GetSubscriptionTiersUseCase {
  GetSubscriptionTiersUseCase(this._repository);

  final SubscriptionTierRepository _repository;

  Future<ApiResult<List<SubscriptionTierEntity>>> call({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
    String? startDate,
    String? familyMemberId,
  }) {
    return _repository.getTiers(
      programId: programId,
      bundleId: bundleId,
      durationDays: durationDays,
      includeFriday: includeFriday,
      startDate: startDate,
      familyMemberId: familyMemberId,
    );
  }
}
