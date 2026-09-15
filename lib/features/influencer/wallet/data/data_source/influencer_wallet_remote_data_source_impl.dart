import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_services.dart';
import '../models/influencer_wallet_dto.dart';
import 'influencer_wallet_remote_data_source.dart';

@Injectable(as: InfluencerWalletRemoteDataSource)
class InfluencerWalletRemoteDataSourceImpl
    implements InfluencerWalletRemoteDataSource {
  const InfluencerWalletRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  @override
  Future<InfluencerWalletResponseDto> getWallet() => _api.getInfluencerWallet();
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
}
