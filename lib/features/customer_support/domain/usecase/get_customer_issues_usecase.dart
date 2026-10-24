import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/domain/repo/customer_support_repository.dart';

@injectable
class GetCustomerIssuesUseCase {
  GetCustomerIssuesUseCase(this._repository);
  final CustomerSupportRepository _repository;
  Future<ApiResult<CustomerIssuesPageEntity>> call({
    required int pageNumber,
    required int pageSize,
    String? status,
    String? typeCode,
  }) => _repository.getIssues(
    pageNumber: pageNumber,
    pageSize: pageSize,
    status: status,
    typeCode: typeCode,
  );
}
