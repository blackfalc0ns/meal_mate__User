import 'package:meal_meat_user/features/customer_support/data/models/response/customer_issue_response_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/response/customer_support_options_response_dto.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';

extension CustomerSupportOptionMapper on CustomerSupportOptionDto {
  CustomerSupportOptionEntity toEntity() => CustomerSupportOptionEntity(
    value: value,
    label: label,
    labelAr: labelAr,
    labelEn: labelEn,
  );
}

extension CustomerIssueMapper on CustomerIssueResponseDto {
  CustomerIssueEntity toEntity() => CustomerIssueEntity(
    id: id,
    status: status,
    version: version,
    subject: subject,
    description: description,
    typeCode: typeCode,
    category: category,
    createdAtUtc: createdAtUtc,
    requesterUserId: requesterUserId,
    messages: messages
        .map(
          (message) => CustomerIssueMessageEntity(
            id: message.id,
            body: message.body,
            createdAtUtc: message.createdAtUtc,
            authorUserId: message.authorUserId,
          ),
        )
        .toList(),
    activeTimingCycle: activeTimingCycle == null
        ? null
        : CustomerIssueTimingEntity(
            firstResponseDeadlineUtc: DateTime.tryParse(
              activeTimingCycle!.firstResponseDeadlineUtc ?? '',
            ),
            resolutionDeadlineUtc: DateTime.tryParse(
              activeTimingCycle!.resolutionDeadlineUtc ?? '',
            ),
            escalationDeadlineUtc: DateTime.tryParse(
              activeTimingCycle!.escalationDeadlineUtc ?? '',
            ),
          ),
  );
}

extension CustomerIssuesPageMapper on CustomerIssuesPageDto {
  CustomerIssuesPageEntity toEntity() => CustomerIssuesPageEntity(
    items: items.map((issue) => issue.toEntity()).toList(),
    totalCount: totalCount,
    pageNumber: pageNumber,
    pageSize: pageSize,
  );
}
