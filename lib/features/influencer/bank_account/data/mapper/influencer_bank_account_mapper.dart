import '../../domain/entities/influencer_bank_account_entity.dart';
import '../models/influencer_bank_account_dto.dart';

extension InfluencerBankDtoMapper on InfluencerBankDto {
  InfluencerBankEntity toEntity() => InfluencerBankEntity(
    id: id ?? '',
    code: code ?? '',
    nameAr: nameAr ?? '',
    nameEn: nameEn ?? '',
    isActive: isActive ?? false,
  );
}

extension InfluencerBankAccountDtoMapper on InfluencerBankAccountResponseDto {
  InfluencerBankAccountEntity toEntity() => InfluencerBankAccountEntity(
    bankName: bankName ?? '',
    accountHolderName: accountHolderName ?? '',
    iban: iban,
    maskedIban: maskedIban ?? '',
    isConfigured: isConfigured ?? false,
  );
}
