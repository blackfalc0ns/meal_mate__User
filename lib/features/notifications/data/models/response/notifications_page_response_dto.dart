import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/notifications/data/models/response/notification_item_response_dto.dart';

part 'notifications_page_response_dto.g.dart';

@JsonSerializable()
class NotificationsPageResponseDto {
  const NotificationsPageResponseDto({
    this.items,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  final List<NotificationItemResponseDto>? items;
  final int? totalCount;
  final int? page;
  final int? pageSize;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  factory NotificationsPageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsPageResponseDtoToJson(this);
}
