import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';

@injectable
class RenewFamilyMemberSubscriptionUseCase {
  const RenewFamilyMemberSubscriptionUseCase(this._repository);

  final FamilyMemberRepository _repository;

  Future<ApiResult<void>> call(String renewalPath) {
    return _repository.renewMemberSubscription(renewalPath);
  }
}
