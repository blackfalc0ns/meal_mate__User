class CreateCustomerIssueRequestDto {
  const CreateCustomerIssueRequestDto({
    required this.typeCode,
    required this.subject,
    required this.description,
    required this.idempotencyKey,
    this.relatedResourceType,
    this.relatedResourceId,
  }) : assert((relatedResourceType == null) == (relatedResourceId == null));

  final String typeCode;
  final String subject;
  final String description;
  final String idempotencyKey;
  final String? relatedResourceType;
  final String? relatedResourceId;

  Map<String, dynamic> toJson() => {
    'typeCode': typeCode,
    'subject': subject,
    'description': description,
    'idempotencyKey': idempotencyKey,
    if (relatedResourceType != null) 'relatedResourceType': relatedResourceType,
    if (relatedResourceId != null) 'relatedResourceId': relatedResourceId,
  };
}
