class CompensationEntity {
  const CompensationEntity({
    required this.id,
    required this.subscriptionId,
    required this.status,
    required this.failedServiceDate,
    required this.totalAmount,
    required this.currency,
    required this.cardRefundAmount,
    required this.walletRefundAmount,
    required this.apologyCreditAmount,
    required this.eligibleForAlternativeDay,
    this.beneficiaryFamilyMemberId,
    this.choiceDeadlineUtc,
    this.serverTimeUtc,
    this.selectedAlternativeDate,
  });
  final String id, subscriptionId, status, failedServiceDate, currency;
  final String? beneficiaryFamilyMemberId, selectedAlternativeDate;
  final double? totalAmount,
      cardRefundAmount,
      walletRefundAmount,
      apologyCreditAmount;
  final bool eligibleForAlternativeDay;
  final DateTime? choiceDeadlineUtc, serverTimeUtc;
  CompensationEntity withChoice({
    required String status,
    String? selectedAlternativeDate,
  }) => CompensationEntity(
    id: id,
    subscriptionId: subscriptionId,
    status: status,
    failedServiceDate: failedServiceDate,
    totalAmount: totalAmount,
    currency: currency,
    cardRefundAmount: cardRefundAmount,
    walletRefundAmount: walletRefundAmount,
    apologyCreditAmount: apologyCreditAmount,
    eligibleForAlternativeDay: eligibleForAlternativeDay,
    beneficiaryFamilyMemberId: beneficiaryFamilyMemberId,
    choiceDeadlineUtc: choiceDeadlineUtc,
    serverTimeUtc: serverTimeUtc,
    selectedAlternativeDate: selectedAlternativeDate,
  );
  bool get isPendingChoice => status == 'PendingChoice';
  bool get canChoose =>
      id.isNotEmpty &&
      isPendingChoice &&
      choiceDeadlineUtc != null &&
      serverTimeUtc != null &&
      choiceDeadlineUtc!.isAfter(serverTimeUtc!);
}
