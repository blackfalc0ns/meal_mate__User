class CustomerSupportOptionEntity {
  const CustomerSupportOptionEntity({
    required this.value,
    required this.label,
    this.labelAr,
    this.labelEn,
  });

  final String value;
  final String label;
  final String? labelAr;
  final String? labelEn;
}

class CustomerIssueEntity {
  const CustomerIssueEntity({
    required this.id,
    required this.status,
    required this.version,
    this.subject,
    this.description,
    this.typeCode,
    this.category,
    this.createdAtUtc,
    this.requesterUserId,
    this.messages = const [],
    this.activeTimingCycle,
  });

  final String id;
  final String status;
  final int version;
  final String? subject;
  final String? description;
  final String? typeCode;
  final String? category;
  final String? createdAtUtc;
  final String? requesterUserId;
  final List<CustomerIssueMessageEntity> messages;
  final CustomerIssueTimingEntity? activeTimingCycle;
}

class CustomerIssueTimingEntity {
  const CustomerIssueTimingEntity({
    this.firstResponseDeadlineUtc,
    this.resolutionDeadlineUtc,
    this.escalationDeadlineUtc,
  });
  final DateTime? firstResponseDeadlineUtc;
  final DateTime? resolutionDeadlineUtc;
  final DateTime? escalationDeadlineUtc;
}

class CustomerIssueMessageEntity {
  const CustomerIssueMessageEntity({
    required this.id,
    required this.body,
    this.createdAtUtc,
    this.authorUserId,
  });
  final String id;
  final String body;
  final String? createdAtUtc;
  final String? authorUserId;
}

class CustomerIssuesPageEntity {
  const CustomerIssuesPageEntity({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });
  final List<CustomerIssueEntity> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
}
