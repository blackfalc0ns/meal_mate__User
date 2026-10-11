import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_programs_page_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_page_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_state.dart';

@injectable
class SubscriptionProgramsViewModel extends Cubit<SubscriptionProgramsState> {
  SubscriptionProgramsViewModel(
    GetSubscriptionProgramsUseCase? _,
    this._getSubscriptionProgramBundlesUseCase,
    this._getSubscriptionProgramsPageUseCase,
  ) : super(const SubscriptionProgramsState());

  final GetSubscriptionProgramBundlesUseCase
  _getSubscriptionProgramBundlesUseCase;
  final GetSubscriptionProgramsPageUseCase _getSubscriptionProgramsPageUseCase;

  int _programsGeneration = 0;
  int _bundlesGeneration = 0;
  static const int _defaultPageSize = 20;

  void doIntent(SubscriptionProgramsEvent event) {
    switch (event) {
      case GetSubscriptionProgramsEvent():
        unawaited(_getSubscriptionPrograms(isRefresh: event.isRefresh));
      case LoadMoreSubscriptionProgramsEvent():
        unawaited(_loadMoreSubscriptionPrograms());
      case RetrySubscriptionProgramsEvent():
        unawaited(_retrySubscriptionPrograms());
      case GetSubscriptionProgramBundlesEvent():
        unawaited(_getSubscriptionProgramBundles(event.programId));
    }
  }

  Future<void> _getSubscriptionPrograms({bool isRefresh = false}) async {
    final generation = ++_programsGeneration;

    if (isRefresh) {
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

    final result = await _getSubscriptionProgramsPageUseCase(
      page: 1,
      pageSize: _defaultPageSize,
    );

    if (isClosed || generation != _programsGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final pageData = result.data;
        final addressCoverage = pageData is SubscriptionProgramsPageEntity
            ? pageData.addressCoverage
            : null;
        final hasDeliveryAddress = pageData is SubscriptionProgramsPageEntity
            ? pageData.hasDeliveryAddress ?? state.hasDeliveryAddress
            : state.hasDeliveryAddress;

        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isSuccess: true,
            programs: result.data.items,
            pagination: result.data.pagination,
            addressCoverage: addressCoverage,
            hasDeliveryAddress: hasDeliveryAddress,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isSuccess: state.programs.isNotEmpty,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadMoreSubscriptionPrograms() async {
    if (state.isLoading || state.isRefreshing || state.isLoadingMore) return;
    if (state.pagination == null || !state.pagination!.hasNextPage) return;

    final targetPage = state.pagination!.page + 1;
    final generation = _programsGeneration;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final result = await _getSubscriptionProgramsPageUseCase(
      page: targetPage,
      pageSize: _defaultPageSize,
    );

    if (isClosed || generation != _programsGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final existingIds = state.programs.map((p) => p.programId).toSet();
        final newItems = result.data.items
            .where((p) => !existingIds.contains(p.programId))
            .toList();

        emit(
          state.copyWith(
            isLoadingMore: false,
            programs: [...state.programs, ...newItems],
            pagination: result.data.pagination,
            clearLoadMoreFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isLoadingMore: false, loadMoreFailure: result.failure),
        );
    }
  }

  Future<void> _retrySubscriptionPrograms() async {
    if (state.loadMoreFailure != null) {
      await _loadMoreSubscriptionPrograms();
    } else {
      await _getSubscriptionPrograms(isRefresh: state.programs.isNotEmpty);
    }
  }

  Future<void> _getSubscriptionProgramBundles(String programId) async {
    final generation = ++_bundlesGeneration;

    emit(state.copyWith(isLoading: true, isSuccess: false, clearFailure: true));

    final result = await _getSubscriptionProgramBundlesUseCase(programId);

    if (isClosed || generation != _bundlesGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            bundles: result.data.bundles
                .where((bundle) => bundle.bundleId.isNotEmpty)
                .toList(),
            hasDeliveryAddress: result.data.hasDeliveryAddress,
            hasAllergies: result.data.hasAllergies,
            hasDietaryPreferences: result.data.hasDietaryPreferences,
            isProfileComplete: result.data.isProfileComplete,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }
}
