import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_notification_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notifications_event.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notifications_state.dart';

@injectable
class NotificationsViewModel extends Cubit<NotificationsState> {
  NotificationsViewModel(
    this._getNotificationsUseCase,
    this._markNotificationReadUseCase,
    this._markAllNotificationsReadUseCase, [
    this._badgeViewModel,
  ]) : super(const NotificationsState());

  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;
  final NotificationBadgeViewModel? _badgeViewModel;

  int _requestGeneration = 0;

  void doIntent(NotificationsEvent event) {
    switch (event) {
      case LoadNotificationsEvent():
        unawaited(load(page: event.page, pageSize: event.pageSize));
      case RefreshNotificationsEvent():
        unawaited(refresh());
      case LoadMoreNotificationsEvent():
        unawaited(loadMore());
      case SelectNotificationCategoryEvent():
        selectCategory(event.category);
      case MarkNotificationReadEvent():
        unawaited(markRead(event.id, onSuccess: event.onSuccessNavigate));
      case MarkAllNotificationsReadEvent():
        unawaited(markAllRead());
      case ClearActionFailureEvent():
        emit(state.copyWith(actionFailure: () => null));
    }
  }

  Future<void> load({int page = 1, int pageSize = 20}) async {
    final generation = ++_requestGeneration;
    emit(state.copyWith(
      isLoading: true,
      initialFailure: () => null,
      page: page,
      pageSize: pageSize,
    ));

    final result = await _getNotificationsUseCase(
      page: page,
      pageSize: pageSize,
    );

    if (isClosed || generation != _requestGeneration) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(
          rawItems: data.items,
          page: data.page,
          pageSize: data.pageSize,
          totalCount: data.totalCount,
          totalPages: data.totalPages,
          hasNextPage: data.hasNextPage,
          isLoading: false,
          initialFailure: () => null,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          isLoading: false,
          initialFailure: () => failure,
        ));
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing || state.isLoading) return;

    final generation = ++_requestGeneration;
    emit(state.copyWith(
      isRefreshing: true,
      refreshFailure: () => null,
    ));

    final result = await _getNotificationsUseCase(
      page: 1,
      pageSize: state.pageSize,
    );

    if (isClosed || generation != _requestGeneration) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(
          rawItems: data.items,
          page: data.page,
          pageSize: data.pageSize,
          totalCount: data.totalCount,
          totalPages: data.totalPages,
          hasNextPage: data.hasNextPage,
          isRefreshing: false,
          refreshFailure: () => null,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          isRefreshing: false,
          refreshFailure: () => failure,
        ));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        state.isLoading ||
        state.isRefreshing ||
        !state.hasNextPage) {
      return;
    }

    emit(state.copyWith(
      isLoadingMore: true,
      loadMoreFailure: () => null,
    ));

    final nextPage = state.page + 1;
    final result = await _getNotificationsUseCase(
      page: nextPage,
      pageSize: state.pageSize,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        final existingIds = state.rawItems.map((e) => e.id).toSet();
        final newItems =
            data.items.where((e) => !existingIds.contains(e.id)).toList();
        final combined = [...state.rawItems, ...newItems];

        emit(state.copyWith(
          rawItems: combined,
          page: data.page,
          totalCount: data.totalCount,
          totalPages: data.totalPages,
          hasNextPage: data.hasNextPage,
          isLoadingMore: false,
          loadMoreFailure: () => null,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          isLoadingMore: false,
          loadMoreFailure: () => failure,
        ));
    }
  }

  void selectCategory(NotificationCategory category) {
    emit(state.copyWith(selectedCategory: category));
  }

  Future<void> markRead(String id, {VoidCallback? onSuccess}) async {
    final item = state.rawItems.where((e) => e.id == id).firstOrNull;
    if (item == null) {
      onSuccess?.call();
      return;
    }

    if (item.isRead) {
      onSuccess?.call();
      return;
    }

    if (state.readingIds.contains(id) || state.isMarkingAllRead) {
      return;
    }

    emit(state.copyWith(
      readingIds: {...state.readingIds, id},
      actionFailure: () => null,
    ));

    final result = await _markNotificationReadUseCase(id);
    final updatedReadingIds = Set<String>.from(state.readingIds)..remove(id);

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        _badgeViewModel?.acknowledgeRead(id);
        final nowUtc = DateTime.now().toUtc();
        final updatedItems = state.rawItems.map((e) {
          if (e.id == id) {
            return e.copyWith(isRead: true, readAtUtc: nowUtc);
          }
          return e;
        }).toList();

        emit(state.copyWith(
          rawItems: updatedItems,
          readingIds: updatedReadingIds,
        ));
        onSuccess?.call();
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          readingIds: updatedReadingIds,
          actionFailure: () => failure,
        ));
    }
  }

  Future<void> markAllRead() async {
    if (state.isMarkingAllRead) return;

    emit(state.copyWith(
      isMarkingAllRead: true,
      actionFailure: () => null,
    ));

    final result = await _markAllNotificationsReadUseCase();

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        _badgeViewModel?.acknowledgeReadAll();
        final nowUtc = DateTime.now().toUtc();
        final updatedItems = state.rawItems
            .map((e) => e.copyWith(isRead: true, readAtUtc: nowUtc))
            .toList();

        emit(state.copyWith(
          rawItems: updatedItems,
          isMarkingAllRead: false,
        ));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          isMarkingAllRead: false,
          actionFailure: () => failure,
        ));
    }
  }
}
