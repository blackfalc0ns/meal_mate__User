import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_bank_account_entity.dart';
import '../repo/influencer_bank_account_repository.dart';

@injectable
class GetInfluencerBankAccountUseCase {
  const GetInfluencerBankAccountUseCase(this._repo);
  final InfluencerBankAccountRepository _repo;
  Future<ApiResult<InfluencerBankAccountEntity>> call() =>
      _repo.getBankAccount();
}
