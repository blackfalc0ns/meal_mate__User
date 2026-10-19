import 'package:json_annotation/json_annotation.dart';

part 'family_checkout_selection_response_dto.g.dart';

/// Data Transfer Object for member checkout selection response.
@JsonSerializable(createToJson: false)
class FamilyCheckoutSelectionResponseDto {
  const FamilyCheckoutSelectionResponseDto({
    this.batchId,
    this.batchVersion,
    this.memberId,
    this.checkoutSelected,
    this.selectedNewSubscriberCount,
  });

  final String? batchId;

  @JsonKey(fromJson: _nullableIntFromJson)
  final int? batchVersion;

  @JsonKey(readValue: _readMemberId)
  final String? memberId;

  @JsonKey(readValue: _readCheckoutSelected)
  final bool? checkoutSelected;

  @JsonKey(fromJson: _nullableIntFromJson)
  final int? selectedNewSubscriberCount;

  factory FamilyCheckoutSelectionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$FamilyCheckoutSelectionResponseDtoFromJson(json);

  static Object? _readMemberId(Map json, String key) =>
      json['memberId'] ?? json['id'];

  static Object? _readCheckoutSelected(Map json, String key) =>
      json['checkoutSelected'] as bool? ?? json['subscribeNow'] as bool?;

  static int? _nullableIntFromJson(dynamic value) {
    if (value is num) return value.toInt();
    if (value != null) return int.tryParse(value.toString());
    return null;
  }
}
