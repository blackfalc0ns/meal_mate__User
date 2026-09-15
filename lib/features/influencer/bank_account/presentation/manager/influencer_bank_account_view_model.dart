import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_bank_account_entity.dart';
import '../../domain/usecase/delete_influencer_bank_account_usecase.dart';
import '../../domain/usecase/get_influencer_bank_account_usecase.dart';
import '../../domain/usecase/get_influencer_banks_usecase.dart';
import '../../domain/usecase/save_influencer_bank_account_usecase.dart';
import 'influencer_bank_account_event.dart';
import 'influencer_bank_account_state.dart';

@injectable
class InfluencerBankAccountViewModel extends Cubit<InfluencerBankAccountState> {
  InfluencerBankAccountViewModel(
    this._getBanks,
    this._getAccount,
    this._saveAccount,
    this._deleteAccount,
  ) : super(const InfluencerBankAccountState());
  final GetInfluencerBanksUseCase _getBanks;
  final GetInfluencerBankAccountUseCase _getAccount;
  final SaveInfluencerBankAccountUseCase _saveAccount;
  final DeleteInfluencerBankAccountUseCase _deleteAccount;
  Future<void> doIntent(InfluencerBankAccountEvent event) => switch (event) {
    LoadInfluencerBankAccountEvent() => _load(forceRefresh: event.forceRefresh),
    SaveInfluencerBankAccountEvent() => _save(event),
    DeleteInfluencerBankAccountEvent() => _delete(),
  };
  Future<void> _load({required bool forceRefresh}) async {
    if (state.isLoading || (!forceRefresh && state.account != null)) return;
    emit(state.copyWith(isLoading: true, isSuccess: false, clearFailure: true));
    final banksResult = await _getBanks();
    final accountResult = await _getAccount();
    switch (accountResult) {
      case ApiSuccessResult<InfluencerBankAccountEntity>(:final data):
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            account: data,
            banks: banksResult is ApiSuccessResult<List<InfluencerBankEntity>>
                ? banksResult.data
                : state.banks,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<InfluencerBankAccountEntity>(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  Future<void> _save(SaveInfluencerBankAccountEvent event) async {
    if (state.isMutating) return;
    emit(
      state.copyWith(isMutating: true, isSuccess: false, clearFailure: true),
    );
    switch (await _saveAccount(
      bankName: event.bankName,
      accountHolderName: event.accountHolderName,
      iban: event.iban,
    )) {
      case ApiSuccessResult<InfluencerBankAccountEntity>(:final data):
        emit(
          state.copyWith(
            isMutating: false,
            isSuccess: true,
            account: data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<InfluencerBankAccountEntity>(:final failure):
        emit(state.copyWith(isMutating: false, failure: failure));
    }
  }

  Future<void> _delete() async {
    if (state.isMutating) return;
    emit(
      state.copyWith(isMutating: true, isSuccess: false, clearFailure: true),
    );
    switch (await _deleteAccount()) {
      case ApiSuccessResult<bool>(:final data):
        emit(
          state.copyWith(
            isMutating: false,
            isSuccess: data,
            clearAccount: data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<bool>(:final failure):
        emit(state.copyWith(isMutating: false, failure: failure));
    }
  }
}
