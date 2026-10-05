import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/network/models/response/pagination_response_dto.dart';
import 'subscription_program_response_dto.dart';

part 'subscription_programs_page_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionProgramsPageResponseDto {
  const SubscriptionProgramsPageResponseDto({
    this.items,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
    this.pagination,
  });

  final List<SubscriptionProgramResponseDto>? items;
  final int? totalCount;
  final int? page;
  final int? pageSize;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;
  final PaginationResponseDto? pagination;

  factory SubscriptionProgramsPageResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionProgramsPageResponseDtoFromJson(json);

  PaginationResponseDto get effectivePagination =>
      pagination ??
      PaginationResponseDto(
        totalCount: totalCount,
        page: page,
        pageSize: pageSize,
        totalPages: totalPages,
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
      );
}
