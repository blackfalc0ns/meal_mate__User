class CustomerSupportOptionDto {
  const CustomerSupportOptionDto({
    required this.value,
    required this.label,
    this.labelAr,
    this.labelEn,
  });

  factory CustomerSupportOptionDto.fromJson(Map<String, dynamic> json) =>
      CustomerSupportOptionDto(
        value: json['value'] as String? ?? '',
        label: json['label'] as String? ?? '',
        labelAr: json['labelAr'] as String?,
        labelEn: json['labelEn'] as String?,
      );

  final String value;
  final String label;
  final String? labelAr;
  final String? labelEn;
}

class CustomerSupportOptionsResponseDto {
  const CustomerSupportOptionsResponseDto({
    required this.issues,
    required this.suggestions,
  });

  factory CustomerSupportOptionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    List<CustomerSupportOptionDto> parse(String key) =>
        ((json[key] as List<dynamic>?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(CustomerSupportOptionDto.fromJson)
            .toList();
    return CustomerSupportOptionsResponseDto(
      issues: parse('issues'),
      suggestions: parse('suggestions'),
    );
  }

  final List<CustomerSupportOptionDto> issues;
  final List<CustomerSupportOptionDto> suggestions;
}
