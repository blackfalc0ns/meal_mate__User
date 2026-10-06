import 'package:json_annotation/json_annotation.dart';

part 'address_coverage_pagination_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class AddressCoveragePaginationResponseDto {
  const AddressCoveragePaginationResponseDto({
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

  factory AddressCoveragePaginationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$AddressCoveragePaginationResponseDtoFromJson(json);
}
