import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_wallet_entity.dart';
import '../../domain/usecase/cancel_influencer_withdrawal_usecase.dart';
import '../../domain/usecase/create_influencer_withdrawal_usecase.dart';
import '../../domain/usecase/get_influencer_wallet_usecase.dart';
import '../../domain/usecase/get_influencer_withdrawals_usecase.dart';
import 'influencer_wallet_event.dart';
import 'influencer_wallet_state.dart';

@injectable
class InfluencerWalletViewModel extends Cubit<InfluencerWalletState> {
  InfluencerWalletViewModel(
    this._getWallet,
    this._getWithdrawals,
    this._createWithdrawal,
    this._cancelWithdrawal,
  ) : super(const InfluencerWalletState());
  final GetInfluencerWalletUseCase _getWallet;
  final GetInfluencerWithdrawalsUseCase _getWithdrawals;
  final CreateInfluencerWithdrawalUseCase _createWithdrawal;
  final CancelInfluencerWithdrawalUseCase _cancelWithdrawal;
  Future<void> doIntent(InfluencerWalletEvent event) => switch (event) {
    LoadInfluencerWalletEvent() => _loadWallet(
      forceRefresh: event.forceRefresh,
    ),
    LoadInfluencerWithdrawalsEvent() => _loadHistory(event),
    SubmitInfluencerWithdrawalEvent() => _submit(event),
    CancelInfluencerWithdrawalEvent() => _cancel(event.id),
  };
  Future<void> _loadWallet({required bool forceRefresh}) async {
    if (state.isLoading || (!forceRefresh && state.wallet != null)) return;
    emit(state.copyWith(isLoading: true, clearFailure: true));
    switch (await _getWallet()) {
      case ApiSuccessResult<InfluencerWalletEntity>(:final data):
        emit(
          state.copyWith(isLoading: false, wallet: data, clearFailure: true),
        );
      case ApiErrorResult<InfluencerWalletEntity>(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  Future<void> _loadHistory(LoadInfluencerWithdrawalsEvent event) async {
    if (state.isHistoryLoading) return;
    emit(
      state.copyWith(
        isHistoryLoading: true,
        selectedStatus: event.status,
        clearStatus: event.status == null,
        clearFailure: true,
      ),
    );
    switch (await _getWithdrawals(
      status: event.status,
      page: event.page,
      pageSize: event.pageSize,
    )) {
      case ApiSuccessResult<InfluencerWithdrawalsPageEntity>(:final data):
        emit(
          state.copyWith(
            isHistoryLoading: false,
            withdrawals: data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<InfluencerWithdrawalsPageEntity>(:final failure):
        emit(state.copyWith(isHistoryLoading: false, failure: failure));
    }
  }

  Future<void> _submit(SubmitInfluencerWithdrawalEvent event) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearFailure: true));
    switch (await _createWithdrawal(
      amount: event.amount,
      correlationId: event.correlationId,
      saveAsDefaultBank: event.saveAsDefaultBank,
      bankName: event.bankName,
      accountHolderName: event.accountHolderName,
      iban: event.iban,
    )) {
      case ApiSuccessResult<InfluencerWithdrawalEntity>():
        emit(state.copyWith(isSubmitting: false, clearFailure: true));
      case ApiErrorResult<InfluencerWithdrawalEntity>(:final failure):
        emit(state.copyWith(isSubmitting: false, failure: failure));
    }
  }

  Future<void> _cancel(String id) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearFailure: true));
    switch (await _cancelWithdrawal(id)) {
      case ApiSuccessResult<InfluencerWithdrawalEntity>():
        emit(state.copyWith(isSubmitting: false, clearFailure: true));
        await _loadHistory(
          LoadInfluencerWithdrawalsEvent(status: state.selectedStatus),
        );
        await _loadWallet(forceRefresh: true);
      case ApiErrorResult<InfluencerWithdrawalEntity>(:final failure):
        emit(state.copyWith(isSubmitting: false, failure: failure));
    }
  }
}
