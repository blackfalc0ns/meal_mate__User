sealed class InfluencerBankAccountEvent {
  const InfluencerBankAccountEvent();
}

final class LoadInfluencerBankAccountEvent extends InfluencerBankAccountEvent {
  const LoadInfluencerBankAccountEvent({this.forceRefresh = false});
  final bool forceRefresh;
}

final class SaveInfluencerBankAccountEvent extends InfluencerBankAccountEvent {
  const SaveInfluencerBankAccountEvent({
    required this.bankName,
    required this.accountHolderName,
    required this.iban,
  });
  final String bankName, accountHolderName, iban;
}

final class DeleteInfluencerBankAccountEvent
    extends InfluencerBankAccountEvent {
  const DeleteInfluencerBankAccountEvent();
}
