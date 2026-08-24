class SubscriptionConversionOptionsResponseDto {
  const SubscriptionConversionOptionsResponseDto({
    this.subscriptionId,
    this.status,
    this.options,
  });

  final String? subscriptionId;
  final String? status;
  final List<SubscriptionConversionOptionResponseDto>? options;

  factory SubscriptionConversionOptionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubscriptionConversionOptionsResponseDto(
      subscriptionId: json['subscriptionId'] as String?,
      status: json['status'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(SubscriptionConversionOptionResponseDto.fromJson)
          .toList(),
    );
  }
}

class SubscriptionConversionOptionResponseDto {
  const SubscriptionConversionOptionResponseDto({
    this.code,
    this.available,
    this.titleAr,
    this.titleEn,
    this.action,
    this.disabledReason,
  });

  final String? code;
  final bool? available;
  final String? titleAr;
  final String? titleEn;
  final String? action;
  final String? disabledReason;

  factory SubscriptionConversionOptionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubscriptionConversionOptionResponseDto(
      code: json['code'] as String?,
      available: json['available'] as bool?,
      titleAr: json['titleAr'] as String?,
      titleEn: json['titleEn'] as String?,
      action: json['action'] as String?,
      disabledReason: json['disabledReason'] as String?,
    );
  }
}
