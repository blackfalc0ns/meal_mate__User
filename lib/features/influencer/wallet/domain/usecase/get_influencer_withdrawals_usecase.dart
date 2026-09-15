import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_wallet_entity.dart';
import '../repo/influencer_wallet_repository.dart';

@injectable
class GetInfluencerWithdrawalsUseCase {
  const GetInfluencerWithdrawalsUseCase(this._repo);
  final InfluencerWalletRepository _repo;
  Future<ApiResult<InfluencerWithdrawalsPageEntity>> call({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) => _repo.getWithdrawals(status: status, page: page, pageSize: pageSize);
}
