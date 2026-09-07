import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';

@injectable
class UpdateFamilyMemberUseCase {
  UpdateFamilyMemberUseCase(this._repository);

  final FamilySubscriptionSetupRepository _repository;

  Future<ApiResult<FamilyFlowCurrentEntity>> call({
    required String memberId,
    required String phone,
    required String displayName,
    String? occupation,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) {
    return _repository.updateFamilyMember(
      memberId: memberId,
      phone: phone,
      displayName: displayName,
      occupation: occupation,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: ageYears,
      deliveryAddressId: deliveryAddressId,
    );
  }
}
