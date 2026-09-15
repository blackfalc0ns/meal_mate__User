import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../repo/influencer_bank_account_repository.dart';

@injectable
class DeleteInfluencerBankAccountUseCase {
  const DeleteInfluencerBankAccountUseCase(this._repo);
  final InfluencerBankAccountRepository _repo;
  Future<ApiResult<bool>> call() => _repo.deleteBankAccount();
}
