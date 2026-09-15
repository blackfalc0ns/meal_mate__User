import '../models/influencer_bank_account_dto.dart';

abstract interface class InfluencerBankAccountRemoteDataSource {
  Future<List<InfluencerBankDto>> getBanks();
  Future<InfluencerBankAccountResponseDto> getBankAccount();
  Future<InfluencerBankAccountResponseDto> saveBankAccount(
    InfluencerBankAccountRequestDto request,
  );
  Future<InfluencerBankAccountDeleteResponseDto> deleteBankAccount();
}
