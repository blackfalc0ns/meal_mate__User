import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/domain/repo/customer_support_repository.dart';

@injectable
class ReplyCustomerIssueUseCase {
  ReplyCustomerIssueUseCase(this._repository);
  final CustomerSupportRepository _repository;
  Future<ApiResult<CustomerIssueEntity>> call({
    required String caseId,
    required String body,
    required int expectedVersion,
    required String idempotencyKey,
    List<String>? attachmentKeys,
  }) => _repository.reply(
    caseId: caseId,
    body: body,
    expectedVersion: expectedVersion,
    idempotencyKey: idempotencyKey,
    attachmentKeys: attachmentKeys,
  );
}
