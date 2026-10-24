import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/customer_support/data/data_source/customer_support_remote_data_source.dart';
import 'package:meal_meat_user/features/customer_support/data/models/request/create_customer_issue_request_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/request/reply_customer_issue_request_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/response/customer_issue_response_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/response/customer_support_options_response_dto.dart';

@Injectable(as: CustomerSupportRemoteDataSource)
class CustomerSupportRemoteDataSourceImpl
    implements CustomerSupportRemoteDataSource {
  CustomerSupportRemoteDataSourceImpl(this._api);
  final ApiServices _api;

  @override
  Future<CustomerSupportOptionsResponseDto> getOptions() =>
      _api.getCustomerSupportOptions();

  @override
  Future<CustomerIssueResponseDto> createIssue(
    CreateCustomerIssueRequestDto request,
  ) => _api.createCustomerIssue(request);

  @override
  Future<CustomerIssuesPageDto> getIssues({
    required int pageNumber,
    required int pageSize,
    String? status,
    String? typeCode,
  }) => _api.getCustomerIssues(pageNumber, pageSize, status, typeCode);

  @override
  Future<CustomerIssueResponseDto> getIssue(String caseId) =>
      _api.getCustomerIssue(caseId);

  @override
  Future<void> reply(String caseId, ReplyCustomerIssueRequestDto request) =>
      _api.replyCustomerIssue(caseId, request);
}
