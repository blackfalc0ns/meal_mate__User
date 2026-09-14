import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../entities/influencer_api_entities.dart';
import '../repo/influencer_repository.dart';

@injectable
class GetInfluencerHomeUseCase {
  const GetInfluencerHomeUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerHomeApiEntity>> call() => _repo.getHome();
}

@injectable
class GetInfluencerLinksUseCase {
  const GetInfluencerLinksUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerLinksEntity>> call() => _repo.getLinks();
}

@injectable
class GetInfluencerProfileUseCase {
  const GetInfluencerProfileUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerProfileApiEntity>> call() => _repo.getProfile();
}

@injectable
class GetInfluencerBanksUseCase {
  const GetInfluencerBanksUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<List<InfluencerBankEntity>>> call() => _repo.getBanks();
}

@injectable
class GetInfluencerBankAccountUseCase {
  const GetInfluencerBankAccountUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerBankInfoEntity>> call() => _repo.getBankAccount();
}

@injectable
class GetInfluencerWalletUseCase {
  const GetInfluencerWalletUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerWalletApiEntity>> call() => _repo.getWallet();
}

@injectable
class GetInfluencerWithdrawalsUseCase {
  const GetInfluencerWithdrawalsUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerPageEntity<InfluencerWithdrawalEntity>>> call({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) => _repo.getWithdrawals(status: status, page: page, pageSize: pageSize);
}

@injectable
class GetInfluencerWithdrawalUseCase {
  const GetInfluencerWithdrawalUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerWithdrawalEntity>> call(String id) =>
      _repo.getWithdrawal(id);
}

@injectable
class GetInfluencerAnalyticsUseCase {
  const GetInfluencerAnalyticsUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerAnalyticsEntity>> call(String period) =>
      _repo.getAnalytics(period);
}
