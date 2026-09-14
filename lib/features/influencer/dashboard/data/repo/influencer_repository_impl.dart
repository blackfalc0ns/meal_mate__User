import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_api_entities.dart';
import '../../domain/repo/influencer_repository.dart';
import '../data_source/influencer_remote_data_source.dart';
import '../mapper/influencer_mapper.dart';
import '../models/influencer_api_models.dart';

@Injectable(as: InfluencerRepository)
class InfluencerRepositoryImpl implements InfluencerRepository {
  InfluencerRepositoryImpl(this._remote);
  final InfluencerRemoteDataSource _remote;
  @override
  Future<ApiResult<List<InfluencerBankEntity>>> getBanks() => safeApiCall(
    () async => (await _remote.getBanks()).map((e) => e.toEntity()).toList(),
  );
  @override
  Future<ApiResult<InfluencerProfileApiEntity>> getProfile() =>
      safeApiCall(() async => (await _remote.getProfile()).toEntity());
  @override
  Future<ApiResult<InfluencerProfileApiEntity>> updateSocialLinks(
    InfluencerSocialLinksEntity links,
  ) => safeApiCall(
    () async => (await _remote.updateSocialLinks(
      InfluencerSocialLinksRequestDto(
        tiktok: links.tiktok,
        instagram: links.instagram,
        whatsapp: links.whatsapp,
        telegram: links.telegram,
        youtube: links.youtube,
        snapchat: links.snapchat,
      ),
    )).toEntity(),
  );
  @override
  Future<ApiResult<InfluencerHomeApiEntity>> getHome() =>
      safeApiCall(() async => (await _remote.getHome()).toEntity());
  @override
  Future<ApiResult<InfluencerLinksEntity>> getLinks() =>
      safeApiCall(() async => (await _remote.getLinks()).toEntity());
  @override
  Future<ApiResult<InfluencerPageEntity<InfluencerActivityApiEntity>>>
  getActivities({required int page, required int pageSize}) => safeApiCall(
    () async => (await _remote.getActivities(
      page: page,
      pageSize: pageSize,
    )).toEntity(),
  );
  @override
  Future<ApiResult<InfluencerWalletApiEntity>> getWallet() =>
      safeApiCall(() async => (await _remote.getWallet()).toEntity());
  @override
  Future<ApiResult<InfluencerBankInfoEntity>> getBankAccount() =>
      safeApiCall(() async => (await _remote.getBankAccount()).toEntity());
  @override
  Future<ApiResult<InfluencerBankInfoEntity>> saveBankAccount({
    required String bankName,
    required String accountHolderName,
    required String iban,
  }) => safeApiCall(
    () async => (await _remote.saveBankAccount(
      InfluencerBankAccountRequestDto(
        bankName: bankName,
        accountHolderName: accountHolderName,
        iban: iban,
      ),
    )).toEntity(),
  );
  @override
  Future<ApiResult<bool>> deleteBankAccount() => safeApiCall(
    () async => (await _remote.deleteBankAccount()).isSuccess ?? false,
  );
  @override
  Future<ApiResult<InfluencerWithdrawalEntity>> createWithdrawal({
    required double amount,
    required String correlationId,
    required bool saveAsDefaultBank,
    String? bankName,
    String? accountHolderName,
    String? iban,
  }) => safeApiCall(
    () async => (await _remote.createWithdrawal(
      InfluencerWithdrawalRequestDto(
        amount: amount,
        withdrawalMethod: 'BankTransfer',
        saveAsDefaultBank: saveAsDefaultBank,
        correlationId: correlationId,
        bankName: bankName,
        accountHolderName: accountHolderName,
        iban: iban,
      ),
    )).toEntity(),
  );
  @override
  Future<ApiResult<InfluencerPageEntity<InfluencerWithdrawalEntity>>>
  getWithdrawals({String? status, required int page, required int pageSize}) =>
      safeApiCall(
        () async => (await _remote.getWithdrawals(
          status: status,
          page: page,
          pageSize: pageSize,
        )).toEntity(),
      );
  @override
  Future<ApiResult<InfluencerWithdrawalEntity>> getWithdrawal(String id) =>
      safeApiCall(() async => (await _remote.getWithdrawal(id)).toEntity());
  @override
  Future<ApiResult<InfluencerWithdrawalEntity>> cancelWithdrawal(String id) =>
      safeApiCall(() async => (await _remote.cancelWithdrawal(id)).toEntity());
  @override
  Future<ApiResult<InfluencerAnalyticsEntity>> getAnalytics(String period) =>
      safeApiCall(() async => (await _remote.getAnalytics(period)).toEntity());
}
