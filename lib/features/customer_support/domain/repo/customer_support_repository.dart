import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';

abstract interface class CustomerSupportRepository {
  Future<ApiResult<List<CustomerSupportOptionEntity>>> getIssueOptions();
  Future<ApiResult<CustomerIssueEntity>> createIssue({
    required String typeCode,
    required String subject,
    required String description,
    required String idempotencyKey,
    String? relatedResourceType,
    String? relatedResourceId,
  });
  Future<ApiResult<CustomerIssuesPageEntity>> getIssues({
    required int pageNumber,
    required int pageSize,
    String? status,
    String? typeCode,
  });
  Future<ApiResult<CustomerIssueEntity>> getIssue(String caseId);
  Future<ApiResult<CustomerIssueEntity>> reply({
    required String caseId,
    required String body,
    required int expectedVersion,
    required String idempotencyKey,
    List<String>? attachmentKeys,
  });
}
