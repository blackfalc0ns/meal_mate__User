import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_services.dart';
import '../models/influencer_api_models.dart';
import 'influencer_remote_data_source.dart';

@Injectable(as: InfluencerRemoteDataSource)
class InfluencerRemoteDataSourceImpl implements InfluencerRemoteDataSource {
  InfluencerRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  @override
  Future<List<InfluencerBankDto>> getBanks() => _api.getInfluencerBanks();
  @override
  Future<InfluencerProfileResponseDto> getProfile() =>
      _api.getInfluencerProfile();
  @override
  Future<InfluencerProfileResponseDto> updateSocialLinks(
    InfluencerSocialLinksRequestDto request,
  ) => _api.updateInfluencerSocialLinks(request);
  @override
  Future<InfluencerHomeResponseDto> getHome() => _api.getInfluencerHome();
  @override
  Future<InfluencerLinksResponseDto> getLinks() => _api.getInfluencerLinks();
  @override
  Future<InfluencerActivitiesPageDto> getActivities({
    required int page,
    required int pageSize,
  }) => _api.getInfluencerActivities(page, pageSize);
  @override
  Future<InfluencerWalletResponseDto> getWallet() => _api.getInfluencerWallet();
  @override
  Future<InfluencerBankAccountResponseDto> getBankAccount() =>
      _api.getInfluencerBankAccount();
  @override
  Future<InfluencerBankAccountResponseDto> saveBankAccount(
    InfluencerBankAccountRequestDto request,
  ) => _api.saveInfluencerBankAccount(request);
  @override
  Future<InfluencerSuccessResponseDto> deleteBankAccount() =>
      _api.deleteInfluencerBankAccount();
  @override
  Future<InfluencerWithdrawalResponseDto> createWithdrawal(
    InfluencerWithdrawalRequestDto request,
  ) => _api.createInfluencerWithdrawal(request);
  @override
  Future<InfluencerWithdrawalsPageDto> getWithdrawals({
    String? status,
    required int page,
    required int pageSize,
  }) => _api.getInfluencerWithdrawals(status, page, pageSize);
  @override
  Future<InfluencerWithdrawalResponseDto> getWithdrawal(String id) =>
      _api.getInfluencerWithdrawal(id);
  @override
  Future<InfluencerWithdrawalResponseDto> cancelWithdrawal(String id) =>
      _api.cancelInfluencerWithdrawal(id);
  @override
  Future<InfluencerAnalyticsResponseDto> getAnalytics(String period) =>
      _api.getInfluencerAnalytics(period);
}
