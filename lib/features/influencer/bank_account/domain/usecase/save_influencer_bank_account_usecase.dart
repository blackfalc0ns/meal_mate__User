import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_bank_account_entity.dart';
import '../repo/influencer_bank_account_repository.dart';

@injectable
class SaveInfluencerBankAccountUseCase {
  const SaveInfluencerBankAccountUseCase(this._repo);
  final InfluencerBankAccountRepository _repo;
  Future<ApiResult<InfluencerBankAccountEntity>> call({
    required String bankName,
    required String accountHolderName,
    required String iban,
  }) => _repo.saveBankAccount(
    bankName: bankName,
    accountHolderName: accountHolderName,
    iban: iban,
  );
}
