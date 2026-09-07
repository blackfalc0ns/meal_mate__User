import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_lookup_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';

@injectable
class LookupFamilyMemberUseCase {
  const LookupFamilyMemberUseCase(this._repository);

  final FamilySubscriptionSetupRepository _repository;

  Future<ApiResult<FamilyMemberLookupEntity>> call(String phone) =>
      _repository.lookupFamilyMember(phone);
}
