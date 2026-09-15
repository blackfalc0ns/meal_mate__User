import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_bank_account_entity.dart';
import '../../domain/repo/influencer_bank_account_repository.dart';
import '../data_source/influencer_bank_account_remote_data_source.dart';
import '../mapper/influencer_bank_account_mapper.dart';
import '../models/influencer_bank_account_dto.dart';

@Injectable(as: InfluencerBankAccountRepository)
class InfluencerBankAccountRepositoryImpl
    implements InfluencerBankAccountRepository {
  const InfluencerBankAccountRepositoryImpl(this._remote);
  final InfluencerBankAccountRemoteDataSource _remote;
  @override
  Future<ApiResult<List<InfluencerBankEntity>>> getBanks() => safeApiCall(
    () async => (await _remote.getBanks()).map((e) => e.toEntity()).toList(),
  );
  @override
  Future<ApiResult<InfluencerBankAccountEntity>> getBankAccount() =>
      safeApiCall(() async => (await _remote.getBankAccount()).toEntity());
  @override
  Future<ApiResult<InfluencerBankAccountEntity>> saveBankAccount({
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
}
