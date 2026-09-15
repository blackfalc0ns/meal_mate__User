import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_wallet_entity.dart';
import '../../domain/repo/influencer_wallet_repository.dart';
import '../data_source/influencer_wallet_remote_data_source.dart';
import '../mapper/influencer_wallet_mapper.dart';
import '../models/influencer_wallet_dto.dart';

@Injectable(as: InfluencerWalletRepository)
class InfluencerWalletRepositoryImpl implements InfluencerWalletRepository {
  const InfluencerWalletRepositoryImpl(this._remote);
  final InfluencerWalletRemoteDataSource _remote;
  @override
  Future<ApiResult<InfluencerWalletEntity>> getWallet() =>
      safeApiCall(() async => (await _remote.getWallet()).toEntity());
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
  Future<ApiResult<InfluencerWithdrawalsPageEntity>> getWithdrawals({
    String? status,
    required int page,
    required int pageSize,
  }) => safeApiCall(
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
}
