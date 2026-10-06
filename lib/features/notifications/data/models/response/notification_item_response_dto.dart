import 'package:json_annotation/json_annotation.dart';

part 'notification_item_response_dto.g.dart';

@JsonSerializable()
class NotificationItemResponseDto {
  const NotificationItemResponseDto({
    this.id,
    this.eventKey,
    this.subjectId,
    this.subscriptionId,
    this.titleAr,
    this.titleEn,
    this.bodyAr,
    this.bodyEn,
    this.deepLink,
    this.createdAtUtc,
    this.readAtUtc,
  });

  final String? id;
  final String? eventKey;
  final String? subjectId;
  final String? subscriptionId;
  final String? titleAr;
  final String? titleEn;
  final String? bodyAr;
  final String? bodyEn;
  final String? deepLink;
  final DateTime? createdAtUtc;
  final DateTime? readAtUtc;

  factory NotificationItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationItemResponseDtoToJson(this);
}
