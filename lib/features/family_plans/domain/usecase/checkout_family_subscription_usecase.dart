import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_response_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_plans_repository.dart';

@injectable
class CheckoutFamilySubscriptionUseCase {
  CheckoutFamilySubscriptionUseCase(this._repository);

  final FamilyPlansRepository _repository;

  Future<ApiResult<FamilyCheckoutResponseEntity>> call(
    FamilyCheckoutRequestEntity request,
  ) {
    return _repository.checkout(request);
  }
}
