import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_wallet_entity.dart';
import '../repo/influencer_wallet_repository.dart';

@injectable
class GetInfluencerWalletUseCase {
  const GetInfluencerWalletUseCase(this._repo);
  final InfluencerWalletRepository _repo;
  Future<ApiResult<InfluencerWalletEntity>> call() => _repo.getWallet();
}
