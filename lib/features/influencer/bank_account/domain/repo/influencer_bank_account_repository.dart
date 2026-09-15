import '../../../../../core/network/api_results.dart';
import '../entities/influencer_bank_account_entity.dart';

abstract interface class InfluencerBankAccountRepository {
  Future<ApiResult<List<InfluencerBankEntity>>> getBanks();
  Future<ApiResult<InfluencerBankAccountEntity>> getBankAccount();
  Future<ApiResult<InfluencerBankAccountEntity>> saveBankAccount({
    required String bankName,
    required String accountHolderName,
    required String iban,
  });
  Future<ApiResult<bool>> deleteBankAccount();
}
