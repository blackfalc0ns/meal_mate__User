class ReplyCustomerIssueRequestDto {
  const ReplyCustomerIssueRequestDto({
    required this.body,
    required this.expectedVersion,
    required this.idempotencyKey,
    this.attachmentKeys,
  });
  final String body;
  final int expectedVersion;
  final String idempotencyKey;
  final List<String>? attachmentKeys;
  Map<String, dynamic> toJson() => {
    'body': body,
    'expectedVersion': expectedVersion,
    'idempotencyKey': idempotencyKey,
    if (attachmentKeys != null) 'attachmentKeys': attachmentKeys,
  };
}
