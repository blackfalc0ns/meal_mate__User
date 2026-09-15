import '../../../../../core/network/api_results.dart';
import '../entities/influencer_wallet_entity.dart';

abstract interface class InfluencerWalletRepository {
  Future<ApiResult<InfluencerWalletEntity>> getWallet();
  Future<ApiResult<InfluencerWithdrawalEntity>> createWithdrawal({
    required double amount,
    required String correlationId,
    required bool saveAsDefaultBank,
    String? bankName,
    String? accountHolderName,
    String? iban,
  });
  Future<ApiResult<InfluencerWithdrawalsPageEntity>> getWithdrawals({
    String? status,
    required int page,
    required int pageSize,
  });
  Future<ApiResult<InfluencerWithdrawalEntity>> getWithdrawal(String id);
  Future<ApiResult<InfluencerWithdrawalEntity>> cancelWithdrawal(String id);
}
