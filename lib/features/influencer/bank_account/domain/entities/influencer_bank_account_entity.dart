class InfluencerBankEntity {
  const InfluencerBankEntity({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.isActive,
  });
  final String id, code, nameAr, nameEn;
  final bool isActive;
}

class InfluencerBankAccountEntity {
  const InfluencerBankAccountEntity({
    required this.bankName,
    required this.accountHolderName,
    required this.maskedIban,
    required this.isConfigured,
    this.iban,
  });
  final String bankName, accountHolderName, maskedIban;
  final String? iban;
  final bool isConfigured;
}
