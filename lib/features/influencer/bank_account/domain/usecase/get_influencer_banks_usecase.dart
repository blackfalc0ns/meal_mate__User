import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_bank_account_entity.dart';
import '../repo/influencer_bank_account_repository.dart';

@injectable
class GetInfluencerBanksUseCase {
  const GetInfluencerBanksUseCase(this._repo);
  final InfluencerBankAccountRepository _repo;
  Future<ApiResult<List<InfluencerBankEntity>>> call() => _repo.getBanks();
}
