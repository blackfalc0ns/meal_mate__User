import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/domain/repo/customer_support_repository.dart';

@injectable
class CreateCustomerIssueUseCase {
  CreateCustomerIssueUseCase(this._repository);
  final CustomerSupportRepository _repository;
  Future<ApiResult<CustomerIssueEntity>> call({
    required String typeCode,
    required String subject,
    required String description,
    required String idempotencyKey,
    String? relatedResourceType,
    String? relatedResourceId,
  }) => _repository.createIssue(
    typeCode: typeCode,
    subject: subject,
    description: description,
    idempotencyKey: idempotencyKey,
    relatedResourceType: relatedResourceType,
    relatedResourceId: relatedResourceId,
  );
}
