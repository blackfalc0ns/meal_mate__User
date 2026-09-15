import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_wallet_entity.dart';
import '../repo/influencer_wallet_repository.dart';

@injectable
class GetInfluencerWithdrawalUseCase {
  const GetInfluencerWithdrawalUseCase(this._repo);
  final InfluencerWalletRepository _repo;
  Future<ApiResult<InfluencerWithdrawalEntity>> call(String id) =>
      _repo.getWithdrawal(id);
}
