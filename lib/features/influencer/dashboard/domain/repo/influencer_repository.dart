import '../../../../../core/network/api_results.dart';
import '../entities/influencer_api_entities.dart';

abstract interface class InfluencerRepository {
  Future<ApiResult<List<InfluencerBankEntity>>> getBanks();
  Future<ApiResult<InfluencerProfileApiEntity>> getProfile();
  Future<ApiResult<InfluencerProfileApiEntity>> updateSocialLinks(
    InfluencerSocialLinksEntity links,
  );
  Future<ApiResult<InfluencerHomeApiEntity>> getHome();
  Future<ApiResult<InfluencerLinksEntity>> getLinks();
  Future<ApiResult<InfluencerPageEntity<InfluencerActivityApiEntity>>>
  getActivities({required int page, required int pageSize});
  Future<ApiResult<InfluencerWalletApiEntity>> getWallet();
  Future<ApiResult<InfluencerBankInfoEntity>> getBankAccount();
  Future<ApiResult<InfluencerBankInfoEntity>> saveBankAccount({
    required String bankName,
    required String accountHolderName,
    required String iban,
  });
  Future<ApiResult<bool>> deleteBankAccount();
  Future<ApiResult<InfluencerWithdrawalEntity>> createWithdrawal({
    required double amount,
    required String correlationId,
    required bool saveAsDefaultBank,
    String? bankName,
    String? accountHolderName,
    String? iban,
  });
  Future<ApiResult<InfluencerPageEntity<InfluencerWithdrawalEntity>>>
  getWithdrawals({String? status, required int page, required int pageSize});
  Future<ApiResult<InfluencerWithdrawalEntity>> getWithdrawal(String id);
  Future<ApiResult<InfluencerWithdrawalEntity>> cancelWithdrawal(String id);
  Future<ApiResult<InfluencerAnalyticsEntity>> getAnalytics(String period);
}
