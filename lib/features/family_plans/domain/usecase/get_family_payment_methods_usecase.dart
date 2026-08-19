import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_payment_method_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_plans_repository.dart';

@injectable
class GetFamilyPaymentMethodsUseCase {
  GetFamilyPaymentMethodsUseCase(this._repository);

  final FamilyPlansRepository _repository;

  Future<ApiResult<List<FamilyPaymentMethodEntity>>> call(double amount) {
    return _repository.getPaymentMethods(amount);
  }
}
