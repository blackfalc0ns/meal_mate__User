import '../../../../../core/network/failures.dart';
import '../../domain/entities/influencer_bank_account_entity.dart';

class InfluencerBankAccountState {
  const InfluencerBankAccountState({
    this.isLoading = false,
    this.isMutating = false,
    this.isSuccess = false,
    this.banks = const [],
    this.account,
    this.failure,
  });
  final bool isLoading, isMutating, isSuccess;
  final List<InfluencerBankEntity> banks;
  final InfluencerBankAccountEntity? account;
  final Failure? failure;
  InfluencerBankAccountState copyWith({
    bool? isLoading,
    bool? isMutating,
    bool? isSuccess,
    List<InfluencerBankEntity>? banks,
    InfluencerBankAccountEntity? account,
    Failure? failure,
    bool clearAccount = false,
    bool clearFailure = false,
  }) => InfluencerBankAccountState(
    isLoading: isLoading ?? this.isLoading,
    isMutating: isMutating ?? this.isMutating,
    isSuccess: isSuccess ?? this.isSuccess,
    banks: banks ?? this.banks,
    account: clearAccount ? null : account ?? this.account,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
