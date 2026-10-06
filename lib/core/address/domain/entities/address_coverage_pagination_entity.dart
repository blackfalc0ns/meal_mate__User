class AddressCoveragePaginationEntity {
  const AddressCoveragePaginationEntity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressCoveragePaginationEntity &&
          runtimeType == other.runtimeType &&
          totalCount == other.totalCount &&
          page == other.page &&
          pageSize == other.pageSize &&
          totalPages == other.totalPages &&
          hasNextPage == other.hasNextPage &&
          hasPreviousPage == other.hasPreviousPage;

  @override
  int get hashCode => Object.hash(
    totalCount,
    page,
    pageSize,
    totalPages,
    hasNextPage,
    hasPreviousPage,
  );
}
