import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';

class NotificationsState {
  const NotificationsState({
    this.rawItems = const [],
    this.selectedCategory = NotificationCategory.all,
    this.page = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.totalPages = 1,
    this.hasNextPage = false,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isMarkingAllRead = false,
    this.readingIds = const {},
    this.initialFailure,
    this.refreshFailure,
    this.loadMoreFailure,
    this.actionFailure,
  });

  final List<NotificationItemEntity> rawItems;
  final NotificationCategory selectedCategory;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isMarkingAllRead;
  final Set<String> readingIds;
  final Failure? initialFailure;
  final Failure? refreshFailure;
  final Failure? loadMoreFailure;
  final Failure? actionFailure;

  bool get hasUnread => rawItems.any((item) => !item.isRead);

  NotificationsState copyWith({
    List<NotificationItemEntity>? rawItems,
    NotificationCategory? selectedCategory,
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasNextPage,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isMarkingAllRead,
    Set<String>? readingIds,
    Failure? Function()? initialFailure,
    Failure? Function()? refreshFailure,
    Failure? Function()? loadMoreFailure,
    Failure? Function()? actionFailure,
  }) {
    return NotificationsState(
      rawItems: rawItems ?? this.rawItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      readingIds: readingIds ?? this.readingIds,
      initialFailure:
          initialFailure != null ? initialFailure() : this.initialFailure,
      refreshFailure:
          refreshFailure != null ? refreshFailure() : this.refreshFailure,
      loadMoreFailure:
          loadMoreFailure != null ? loadMoreFailure() : this.loadMoreFailure,
      actionFailure:
          actionFailure != null ? actionFailure() : this.actionFailure,
    );
  }
}
