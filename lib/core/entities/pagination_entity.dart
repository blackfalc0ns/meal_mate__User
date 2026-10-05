class PaginationEntity {
  const PaginationEntity({
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationEntity copyWith({
    int? totalCount,
    int? page,
    int? pageSize,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginationEntity(
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationEntity &&
          runtimeType == other.runtimeType &&
          totalCount == other.totalCount &&
          page == other.page &&
          pageSize == other.pageSize &&
          totalPages == other.totalPages &&
          hasNextPage == other.hasNextPage &&
          hasPreviousPage == other.hasPreviousPage;

  @override
  int get hashCode =>
      totalCount.hashCode ^
      page.hashCode ^
      pageSize.hashCode ^
      totalPages.hashCode ^
      hasNextPage.hashCode ^
      hasPreviousPage.hashCode;
}
