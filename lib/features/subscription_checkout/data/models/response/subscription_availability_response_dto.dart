import 'package:json_annotation/json_annotation.dart';

part 'subscription_availability_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionAvailabilityResponseDto {
  const SubscriptionAvailabilityResponseDto({
    this.status,
    this.coveredRestaurantCount,
    this.eligibleRestaurantCount,
    this.checkedAtUtc,
    this.effectiveStartDate,
    this.messageCode,
    this.scope,
    this.canSelect,
    this.missingStep,
    this.actionEndpoint,
    this.failureReasons,
    this.failureReasonCounts,
  });

  final String? status;
  final int? coveredRestaurantCount;
  final int? eligibleRestaurantCount;
  final String? checkedAtUtc;
  final String? effectiveStartDate;
  final String? messageCode;
  final String? scope;
  final bool? canSelect;
  final String? missingStep;
  final String? actionEndpoint;
  @JsonKey(fromJson: _parseFailureReasons)
  final List<String>? failureReasons;
  @JsonKey(fromJson: _parseFailureReasonCounts)
  final Map<String, int>? failureReasonCounts;

  static List<String>? _parseFailureReasons(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is Map) {
      return value.keys.map((e) => e.toString()).toList();
    }
    if (value is String) {
      return [value];
    }
    return null;
  }

  static Map<String, int>? _parseFailureReasonCounts(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final result = <String, int>{};
      value.forEach((key, val) {
        if (val is num) {
          result[key.toString()] = val.toInt();
        } else if (val is String) {
          final parsed = int.tryParse(val);
          if (parsed != null) result[key.toString()] = parsed;
        }
      });
      return result;
    }
    return null;
  }

  factory SubscriptionAvailabilityResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    final parsed = _$SubscriptionAvailabilityResponseDtoFromJson(json);
    final reasonsRaw =
        json['failureReasons'] ??
        json['failure_reasons'] ??
        json['FailureReasons'];
    return SubscriptionAvailabilityResponseDto(
      status: parsed.status,
      coveredRestaurantCount: parsed.coveredRestaurantCount,
      eligibleRestaurantCount: parsed.eligibleRestaurantCount,
      checkedAtUtc: parsed.checkedAtUtc,
      effectiveStartDate: parsed.effectiveStartDate,
      messageCode: parsed.messageCode ?? (json['messageCode'] as String?),
      scope: parsed.scope,
      canSelect: parsed.canSelect ?? (json['canSelect'] as bool?),
      missingStep:
          (json['missingStep'] ?? json['missing_step'] ?? json['MissingStep'])
              as String?,
      actionEndpoint:
          (json['actionEndpoint'] ??
                  json['action_endpoint'] ??
                  json['ActionEndpoint'] ??
                  json['endpoint'])
              as String?,
      failureReasons: parsed.failureReasons ?? _parseFailureReasons(reasonsRaw),
      failureReasonCounts:
          parsed.failureReasonCounts ?? _parseFailureReasonCounts(reasonsRaw),
    );
  }
}
