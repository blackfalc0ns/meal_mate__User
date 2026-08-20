import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_subscription_repository.dart';

@injectable
class UpdateFamilyMemberUseCase {
  UpdateFamilyMemberUseCase(this._repository);

  final FamilySubscriptionRepository _repository;

  Future<ApiResult<FamilyFlowCurrentEntity>> call({
    required String memberId,
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) {
    return _repository.updateFamilyMember(
      memberId: memberId,
      displayName: displayName,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: ageYears,
      deliveryAddressId: deliveryAddressId,
    );
  }
}
