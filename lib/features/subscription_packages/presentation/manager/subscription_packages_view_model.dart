import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/usecase/get_subscription_packages_usecase.dart';
import 'subscription_packages_event.dart';
import 'subscription_packages_state.dart';

@injectable
class SubscriptionPackagesViewModel extends Cubit<SubscriptionPackagesState> {
  SubscriptionPackagesViewModel(this._getSubscriptionPackagesUseCase)
    : super(const SubscriptionPackagesState());

  final GetSubscriptionPackagesUseCase _getSubscriptionPackagesUseCase;

  int _packagesGeneration = 0;
  static const int _defaultPageSize = 20;

  void doIntent(SubscriptionPackagesEvent event) {
    switch (event) {
      case GetSubscriptionPackagesEvent():
        unawaited(
          _getSubscriptionPackages(event.programId, isRefresh: event.isRefresh),
        );
      case LoadMoreSubscriptionPackagesEvent():
        unawaited(_loadMoreSubscriptionPackages());
      case RetrySubscriptionPackagesEvent():
        unawaited(_retrySubscriptionPackages());
    }
  }

  Future<void> _getSubscriptionPackages(
    String programId, {
    bool isRefresh = false,
  }) async {
    final isProgramChange = programId != state.programId;
    final generation = ++_packagesGeneration;

    if (isProgramChange) {
      emit(
        state.copyWith(
          programId: programId,
          isLoading: true,
          isSuccess: false,
          bundles: const [],
          clearPagination: true,
          clearFailure: true,
          clearLoadMoreFailure: true,
        ),
      );
    } else if (isRefresh) {
      emit(
        state.copyWith(
          isRefreshing: true,
          clearFailure: true,
          clearLoadMoreFailure: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
          clearLoadMoreFailure: true,
        ),
      );
    }

    final result = await _getSubscriptionPackagesUseCase(
      programId,
      page: 1,
      pageSize: _defaultPageSize,
    );

    if (isClosed || generation != _packagesGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isSuccess: true,
            bundles: result.data.bundles
                .where((bundle) => bundle.bundleId.isNotEmpty)
                .toList(),
            pagination: result.data.pagination,
            hasDeliveryAddress: result.data.hasDeliveryAddress,
            hasAllergies: result.data.hasAllergies,
            hasDietaryPreferences: result.data.hasDietaryPreferences,
            isProfileComplete: result.data.isProfileComplete,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isSuccess: state.bundles.isNotEmpty,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadMoreSubscriptionPackages() async {
    if (state.isLoading || state.isRefreshing || state.isLoadingMore) return;
    if (state.pagination == null || !state.pagination!.hasNextPage) return;
    if (state.programId.isEmpty) return;

    final targetPage = state.pagination!.page + 1;
    final generation = _packagesGeneration;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final result = await _getSubscriptionPackagesUseCase(
      state.programId,
      page: targetPage,
      pageSize: _defaultPageSize,
    );

    if (isClosed || generation != _packagesGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final existingIds = state.bundles.map((b) => b.bundleId).toSet();
        final newItems = result.data.bundles
            .where(
              (b) => b.bundleId.isNotEmpty && !existingIds.contains(b.bundleId),
            )
            .toList();

        emit(
          state.copyWith(
            isLoadingMore: false,
            bundles: [...state.bundles, ...newItems],
            pagination: result.data.pagination,
            hasDeliveryAddress: result.data.hasDeliveryAddress,
            hasAllergies: result.data.hasAllergies,
            hasDietaryPreferences: result.data.hasDietaryPreferences,
            isProfileComplete: result.data.isProfileComplete,
            clearLoadMoreFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isLoadingMore: false, loadMoreFailure: result.failure),
        );
    }
  }

  Future<void> _retrySubscriptionPackages() async {
    if (state.loadMoreFailure != null) {
      await _loadMoreSubscriptionPackages();
    } else if (state.programId.isNotEmpty) {
      await _getSubscriptionPackages(
        state.programId,
        isRefresh: state.bundles.isNotEmpty,
      );
    }
  }
}
