import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_wallet_entity.dart';
import '../repo/influencer_wallet_repository.dart';

@injectable
class CancelInfluencerWithdrawalUseCase {
  const CancelInfluencerWithdrawalUseCase(this._repo);
  final InfluencerWalletRepository _repo;
  Future<ApiResult<InfluencerWithdrawalEntity>> call(String id) =>
      _repo.cancelWithdrawal(id);
}
