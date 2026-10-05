import 'package:json_annotation/json_annotation.dart';

part 'pagination_response_dto.g.dart';

@JsonSerializable()
class PaginationResponseDto {
  const PaginationResponseDto({
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  final int? totalCount;
  final int? page;
  final int? pageSize;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  factory PaginationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationResponseDtoToJson(this);
}
