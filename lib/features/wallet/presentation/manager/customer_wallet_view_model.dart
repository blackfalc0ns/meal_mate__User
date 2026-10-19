import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/wallet/domain/usecase/get_customer_referral_summary_usecase.dart';
import 'package:meal_meat_user/features/wallet/domain/usecase/get_customer_wallet_transactions_usecase.dart';
import 'package:meal_meat_user/features/wallet/domain/usecase/get_customer_wallet_usecase.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_event.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_state.dart';

@injectable
class CustomerWalletViewModel extends Cubit<CustomerWalletState> {
  CustomerWalletViewModel(
    this._getWalletUseCase,
    this._getTransactionsUseCase,
    this._getReferralSummaryUseCase,
  ) : super(const CustomerWalletState());

  final GetCustomerWalletUseCase _getWalletUseCase;
  final GetCustomerWalletTransactionsUseCase _getTransactionsUseCase;
  final GetCustomerReferralSummaryUseCase _getReferralSummaryUseCase;

  static const int _pageSize = 20;

  void doIntent(CustomerWalletEvent event) {
    switch (event) {
      case LoadCustomerWalletEvent():
        unawaited(_load(isRefresh: false));
      case RefreshCustomerWalletEvent():
        unawaited(_load(isRefresh: true));
      case FilterWalletTransactionsEvent(:final walletType):
        unawaited(_filter(walletType));
      case LoadMoreWalletTransactionsEvent():
        unawaited(_loadMore());
      case LoadCustomerReferralEvent():
        unawaited(_loadReferral());
    }
  }

  Future<void> _load({required bool isRefresh}) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearFailure: true));
    } else {
      emit(state.copyWith(isLoading: true, clearFailure: true));
    }

    final walletResult = await _getWalletUseCase();
    final txResult = await _getTransactionsUseCase(
      walletType: state.selectedWalletType,
      page: 1,
      pageSize: _pageSize,
    );

    if (isClosed) return;

    var newState = state.copyWith(
      isLoading: false,
      isRefreshing: false,
    );

    switch (walletResult) {
      case ApiSuccessResult(:final data):
        newState = newState.copyWith(
          wallet: data,
          clearFailure: true,
        );
      case ApiErrorResult(:final failure):
        newState = newState.copyWith(failure: failure);
    }

    switch (txResult) {
      case ApiSuccessResult(:final data):
        newState = newState.copyWith(
          transactions: data.items,
          totalCount: data.totalCount,
          currentPage: data.page,
          hasMore: data.hasMore,
          clearTransactionsFailure: true,
        );
      case ApiErrorResult(:final failure):
        newState = newState.copyWith(transactionsFailure: failure);
    }

    emit(newState);
  }

  Future<void> _filter(String? walletType) async {
    final normalized = (walletType != null && walletType.isNotEmpty)
        ? walletType
        : null;
    emit(
      state.copyWith(
        selectedWalletType: normalized,
        clearSelectedWalletType: normalized == null,
        isTransactionsLoading: true,
        clearTransactionsFailure: true,
      ),
    );

    final txResult = await _getTransactionsUseCase(
      walletType: normalized,
      page: 1,
      pageSize: _pageSize,
    );

    if (isClosed) return;

    switch (txResult) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            isTransactionsLoading: false,
            transactions: data.items,
            totalCount: data.totalCount,
            currentPage: data.page,
            hasMore: data.hasMore,
            clearTransactionsFailure: true,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            isTransactionsLoading: false,
            transactionsFailure: failure,
          ),
        );
    }
  }

  Future<void> _loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isLoadingMore: true));

    final txResult = await _getTransactionsUseCase(
      walletType: state.selectedWalletType,
      page: nextPage,
      pageSize: _pageSize,
    );

    if (isClosed) return;

    switch (txResult) {
      case ApiSuccessResult(:final data):
        final combined = [
          ...state.transactions,
          ...data.items,
        ];
        emit(
          state.copyWith(
            isLoadingMore: false,
            transactions: combined,
            totalCount: data.totalCount,
            currentPage: data.page,
            hasMore: data.hasMore,
            clearTransactionsFailure: true,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            isLoadingMore: false,
            transactionsFailure: failure,
          ),
        );
    }
  }

  Future<void> _loadReferral() async {
    final result = await _getReferralSummaryUseCase();
    if (isClosed) return;

    if (result is ApiSuccessResult) {
      emit(state.copyWith(referral: (result as ApiSuccessResult).data));
    }
  }
}
