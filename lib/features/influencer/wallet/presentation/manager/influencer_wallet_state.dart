import 'package:meal_meat_user/core/errors/failures.dart';
import '../../domain/entities/influencer_wallet_entity.dart';

class InfluencerWalletState {
  const InfluencerWalletState({
    this.isLoading = false,
    this.isHistoryLoading = false,
    this.isSubmitting = false,
    this.wallet,
    this.withdrawals,
    this.selectedStatus,
    this.failure,
  });
  final bool isLoading, isHistoryLoading, isSubmitting;
  final InfluencerWalletEntity? wallet;
  final InfluencerWithdrawalsPageEntity? withdrawals;
  final String? selectedStatus;
  final Failure? failure;
  InfluencerWalletState copyWith({
    bool? isLoading,
    bool? isHistoryLoading,
    bool? isSubmitting,
    InfluencerWalletEntity? wallet,
    InfluencerWithdrawalsPageEntity? withdrawals,
    String? selectedStatus,
    Failure? failure,
    bool clearStatus = false,
    bool clearFailure = false,
  }) => InfluencerWalletState(
    isLoading: isLoading ?? this.isLoading,
    isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    wallet: wallet ?? this.wallet,
    withdrawals: withdrawals ?? this.withdrawals,
    selectedStatus: clearStatus ? null : selectedStatus ?? this.selectedStatus,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
