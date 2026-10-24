import 'package:meal_meat_user/features/customer_support/data/models/request/create_customer_issue_request_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/request/reply_customer_issue_request_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/response/customer_issue_response_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/response/customer_support_options_response_dto.dart';

abstract interface class CustomerSupportRemoteDataSource {
  Future<CustomerSupportOptionsResponseDto> getOptions();
  Future<CustomerIssueResponseDto> createIssue(
    CreateCustomerIssueRequestDto request,
  );
  Future<CustomerIssuesPageDto> getIssues({
    required int pageNumber,
    required int pageSize,
    String? status,
    String? typeCode,
  });
  Future<CustomerIssueResponseDto> getIssue(String caseId);
  Future<void> reply(String caseId, ReplyCustomerIssueRequestDto request);
}
