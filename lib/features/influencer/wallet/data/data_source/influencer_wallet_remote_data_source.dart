import '../models/influencer_wallet_dto.dart';

abstract interface class InfluencerWalletRemoteDataSource {
  Future<InfluencerWalletResponseDto> getWallet();
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
}
