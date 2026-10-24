import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/domain/repo/customer_support_repository.dart';

@injectable
class GetCustomerIssueOptionsUseCase {
  GetCustomerIssueOptionsUseCase(this._repository);
  final CustomerSupportRepository _repository;
  Future<ApiResult<List<CustomerSupportOptionEntity>>> call() =>
      _repository.getIssueOptions();
}
