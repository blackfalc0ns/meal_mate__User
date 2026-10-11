import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/network/models/response/pagination_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';
import 'subscription_program_response_dto.dart';

part 'subscription_programs_page_response_dto.g.dart';

SubscriptionAvailabilityResponseDto? _parseAddressCoverage(dynamic json) {
  if (json == null) return null;
  if (json is Map<String, dynamic>) {
    return SubscriptionAvailabilityResponseDto.fromJson(json);
  }
  if (json is Map) {
    return SubscriptionAvailabilityResponseDto.fromJson(
      Map<String, dynamic>.from(json),
    );
  }
  if (json is String) {
    return SubscriptionAvailabilityResponseDto(status: json);
  }
  return null;
}

@JsonSerializable(createToJson: false)
class SubscriptionProgramsPageResponseDto {
  const SubscriptionProgramsPageResponseDto({
    this.items,
    this.programs,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
    this.pagination,
    this.addressCoverage,
    this.hasDeliveryAddress,
  });

  final List<SubscriptionProgramResponseDto>? items;
  final List<SubscriptionProgramResponseDto>? programs;
  final int? totalCount;
  final int? page;
  final int? pageSize;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;
  final PaginationResponseDto? pagination;
  @JsonKey(fromJson: _parseAddressCoverage)
  final SubscriptionAvailabilityResponseDto? addressCoverage;
  final bool? hasDeliveryAddress;

  List<SubscriptionProgramResponseDto> get effectiveItems =>
      items ?? programs ?? const [];

  factory SubscriptionProgramsPageResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionProgramsPageResponseDtoFromJson(json);

  PaginationResponseDto get effectivePagination =>
      pagination ??
      PaginationResponseDto(
        totalCount: totalCount ?? effectiveItems.length,
        page: page ?? 1,
        pageSize:
            pageSize ??
            (effectiveItems.isNotEmpty ? effectiveItems.length : 20),
        totalPages:
            totalPages ??
            ((totalCount != null && pageSize != null && pageSize! > 0)
                ? (totalCount! / pageSize!).ceil()
                : 1),
        hasNextPage: hasNextPage ?? false,
        hasPreviousPage: hasPreviousPage ?? false,
      );
}
