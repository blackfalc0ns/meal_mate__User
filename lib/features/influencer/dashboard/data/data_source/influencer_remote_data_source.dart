import '../models/influencer_api_models.dart';

abstract interface class InfluencerRemoteDataSource {
  Future<List<InfluencerBankDto>> getBanks();
  Future<InfluencerProfileResponseDto> getProfile();
  Future<InfluencerProfileResponseDto> updateSocialLinks(
    InfluencerSocialLinksRequestDto request,
  );
  Future<InfluencerHomeResponseDto> getHome();
  Future<InfluencerLinksResponseDto> getLinks();
  Future<InfluencerActivitiesPageDto> getActivities({
    required int page,
    required int pageSize,
  });
  Future<InfluencerWalletResponseDto> getWallet();
  Future<InfluencerBankAccountResponseDto> getBankAccount();
  Future<InfluencerBankAccountResponseDto> saveBankAccount(
    InfluencerBankAccountRequestDto request,
  );
  Future<InfluencerSuccessResponseDto> deleteBankAccount();
  Future<InfluencerWithdrawalResponseDto> createWithdrawal(
    InfluencerWithdrawalRequestDto request,
  );
  Future<InfluencerWithdrawalsPageDto> getWithdrawals({
    String? status,
    required int page,
    required int pageSize,
  });
  Future<InfluencerWithdrawalResponseDto> getWithdrawal(String id);
  Future<InfluencerWithdrawalResponseDto> cancelWithdrawal(String id);
  Future<InfluencerAnalyticsResponseDto> getAnalytics(String period);
}
