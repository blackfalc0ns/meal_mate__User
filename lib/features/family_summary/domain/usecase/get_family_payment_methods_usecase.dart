import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/domain/repo/family_summary_repository.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

@injectable
class GetFamilyPaymentMethodsUseCase {
  GetFamilyPaymentMethodsUseCase(this._repository);

  final FamilySummaryRepository _repository;

  Future<ApiResult<List<PaymentMethodEntity>>> call(double amount) {
    return _repository.getFamilyPaymentMethods(amount);
  }
}
