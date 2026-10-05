import '../../entities/pagination_entity.dart';
import '../models/response/pagination_response_dto.dart';

extension PaginationResponseDtoMapper on PaginationResponseDto {
  PaginationEntity toEntity() {
    return PaginationEntity(
      totalCount: totalCount ?? 0,
      page: page ?? 1,
      pageSize: pageSize ?? 20,
      totalPages: totalPages ?? 0,
      hasNextPage: hasNextPage ?? false,
      hasPreviousPage: hasPreviousPage ?? false,
    );
  }
}

extension NullablePaginationResponseDtoMapper on PaginationResponseDto? {
  PaginationEntity? toEntityOrNull() {
    final dto = this;
    if (dto == null) return null;
    return dto.toEntity();
  }
}
