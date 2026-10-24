class CustomerIssueResponseDto {
  const CustomerIssueResponseDto({
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

  factory CustomerIssueResponseDto.fromJson(Map<String, dynamic> json) =>
      CustomerIssueResponseDto(
        id: json['id'] as String? ?? '',
        status: json['status'] as String? ?? '',
        version: json['version'] as int? ?? 0,
        subject: json['subject'] as String?,
        description: json['description'] as String?,
        typeCode: json['typeCode'] as String?,
        category: json['category'] as String?,
        createdAtUtc: json['createdAtUtc'] as String?,
        requesterUserId: json['requesterUserId'] as String?,
        messages: ((json['messages'] as List<dynamic>?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(CustomerIssueMessageDto.fromJson)
            .toList(),
        activeTimingCycle: json['activeTimingCycle'] is Map<String, dynamic>
            ? CustomerIssueTimingDto.fromJson(
                json['activeTimingCycle'] as Map<String, dynamic>,
              )
            : null,
      );

  final String id;
  final String status;
  final int version;
  final String? subject;
  final String? description;
  final String? typeCode;
  final String? category;
  final String? createdAtUtc;
  final String? requesterUserId;
  final List<CustomerIssueMessageDto> messages;
  final CustomerIssueTimingDto? activeTimingCycle;
}

class CustomerIssueTimingDto {
  const CustomerIssueTimingDto({
    this.firstResponseDeadlineUtc,
    this.resolutionDeadlineUtc,
    this.escalationDeadlineUtc,
  });
  factory CustomerIssueTimingDto.fromJson(Map<String, dynamic> json) =>
      CustomerIssueTimingDto(
        firstResponseDeadlineUtc: json['firstResponseDeadlineUtc'] as String?,
        resolutionDeadlineUtc: json['resolutionDeadlineUtc'] as String?,
        escalationDeadlineUtc: json['escalationDeadlineUtc'] as String?,
      );
  final String? firstResponseDeadlineUtc;
  final String? resolutionDeadlineUtc;
  final String? escalationDeadlineUtc;
}

class CustomerIssueMessageDto {
  const CustomerIssueMessageDto({
    required this.id,
    required this.body,
    this.createdAtUtc,
    this.authorUserId,
  });
  factory CustomerIssueMessageDto.fromJson(Map<String, dynamic> json) =>
      CustomerIssueMessageDto(
        id: json['id'] as String? ?? '',
        body: json['body'] as String? ?? '',
        createdAtUtc: json['createdAtUtc'] as String?,
        authorUserId: json['authorUserId'] as String?,
      );
  final String id;
  final String body;
  final String? createdAtUtc;
  final String? authorUserId;
}

class CustomerIssuesPageDto {
  const CustomerIssuesPageDto({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });
  factory CustomerIssuesPageDto.fromJson(Map<String, dynamic> json) =>
      CustomerIssuesPageDto(
        items: ((json['items'] as List<dynamic>?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(CustomerIssueResponseDto.fromJson)
            .toList(),
        totalCount: json['totalCount'] as int? ?? 0,
        pageNumber: json['pageNumber'] as int? ?? 1,
        pageSize: json['pageSize'] as int? ?? 20,
      );
  final List<CustomerIssueResponseDto> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
}
