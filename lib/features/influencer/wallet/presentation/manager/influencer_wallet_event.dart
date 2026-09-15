sealed class InfluencerWalletEvent {
  const InfluencerWalletEvent();
}

final class LoadInfluencerWalletEvent extends InfluencerWalletEvent {
  const LoadInfluencerWalletEvent({this.forceRefresh = false});
  final bool forceRefresh;
}

final class LoadInfluencerWithdrawalsEvent extends InfluencerWalletEvent {
  const LoadInfluencerWithdrawalsEvent({
    this.status,
    this.page = 1,
    this.pageSize = 20,
  });
  final String? status;
  final int page, pageSize;
}

final class SubmitInfluencerWithdrawalEvent extends InfluencerWalletEvent {
  const SubmitInfluencerWithdrawalEvent({
    required this.amount,
    required this.correlationId,
    required this.saveAsDefaultBank,
    this.bankName,
    this.accountHolderName,
    this.iban,
  });
  final double amount;
  final String correlationId;
  final bool saveAsDefaultBank;
  final String? bankName, accountHolderName, iban;
}

final class CancelInfluencerWithdrawalEvent extends InfluencerWalletEvent {
  const CancelInfluencerWithdrawalEvent(this.id);
  final String id;
}
