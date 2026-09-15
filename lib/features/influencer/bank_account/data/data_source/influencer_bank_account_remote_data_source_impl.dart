import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_services.dart';
import '../models/influencer_bank_account_dto.dart';
import 'influencer_bank_account_remote_data_source.dart';

@Injectable(as: InfluencerBankAccountRemoteDataSource)
class InfluencerBankAccountRemoteDataSourceImpl
    implements InfluencerBankAccountRemoteDataSource {
  const InfluencerBankAccountRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  @override
  Future<List<InfluencerBankDto>> getBanks() => _api.getInfluencerBanks();
  @override
  Future<InfluencerBankAccountResponseDto> getBankAccount() =>
      _api.getInfluencerBankAccount();
  @override
  Future<InfluencerBankAccountResponseDto> saveBankAccount(
    InfluencerBankAccountRequestDto request,
  ) => _api.saveInfluencerBankAccount(request);
  @override
  Future<InfluencerBankAccountDeleteResponseDto> deleteBankAccount() =>
      _api.deleteInfluencerBankAccount();
}
