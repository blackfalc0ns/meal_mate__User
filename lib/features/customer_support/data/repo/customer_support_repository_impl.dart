import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_support/data/data_source/customer_support_remote_data_source.dart';
import 'package:meal_meat_user/features/customer_support/data/mapper/customer_support_mapper.dart';
import 'package:meal_meat_user/features/customer_support/data/models/request/create_customer_issue_request_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/request/reply_customer_issue_request_dto.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/domain/repo/customer_support_repository.dart';

@Injectable(as: CustomerSupportRepository)
class CustomerSupportRepositoryImpl implements CustomerSupportRepository {
  CustomerSupportRepositoryImpl(this._remote);
  final CustomerSupportRemoteDataSource _remote;

  @override
  Future<ApiResult<List<CustomerSupportOptionEntity>>> getIssueOptions() =>
      safeApiCall(
        () async => (await _remote.getOptions()).issues
            .map((option) => option.toEntity())
            .toList(),
      );

  @override
  Future<ApiResult<CustomerIssueEntity>> createIssue({
    required String typeCode,
    required String subject,
    required String description,
    required String idempotencyKey,
    String? relatedResourceType,
    String? relatedResourceId,
  }) => safeApiCall(
    () async => (await _remote.createIssue(
      CreateCustomerIssueRequestDto(
        typeCode: typeCode,
        subject: subject,
        description: description,
        idempotencyKey: idempotencyKey,
        relatedResourceType: relatedResourceType,
        relatedResourceId: relatedResourceId,
      ),
    )).toEntity(),
  );

  @override
  Future<ApiResult<CustomerIssuesPageEntity>> getIssues({
    required int pageNumber,
    required int pageSize,
    String? status,
    String? typeCode,
  }) => safeApiCall(
    () async => (await _remote.getIssues(
      pageNumber: pageNumber,
      pageSize: pageSize,
      status: status,
      typeCode: typeCode,
    )).toEntity(),
  );

  @override
  Future<ApiResult<CustomerIssueEntity>> getIssue(String caseId) =>
      safeApiCall(() async => (await _remote.getIssue(caseId)).toEntity());

  @override
  Future<ApiResult<CustomerIssueEntity>> reply({
    required String caseId,
    required String body,
    required int expectedVersion,
    required String idempotencyKey,
    List<String>? attachmentKeys,
  }) => safeApiCall(() async {
    await _remote.reply(
      caseId,
      ReplyCustomerIssueRequestDto(
        body: body,
        expectedVersion: expectedVersion,
        idempotencyKey: idempotencyKey,
        attachmentKeys: attachmentKeys,
      ),
    );
    return (await _remote.getIssue(caseId)).toEntity();
  });
}
