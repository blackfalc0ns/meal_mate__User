import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../entities/influencer_api_entities.dart';
import '../repo/influencer_repository.dart';

@injectable
class UpdateInfluencerSocialLinksUseCase {
  const UpdateInfluencerSocialLinksUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerProfileApiEntity>> call(
    InfluencerSocialLinksEntity links,
  ) => _repo.updateSocialLinks(links);
}

@injectable
class SaveInfluencerBankAccountUseCase {
  const SaveInfluencerBankAccountUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerBankInfoEntity>> call({
    required String bankName,
    required String accountHolderName,
    required String iban,
  }) => _repo.saveBankAccount(
    bankName: bankName,
    accountHolderName: accountHolderName,
    iban: iban,
  );
}

@injectable
class DeleteInfluencerBankAccountUseCase {
  const DeleteInfluencerBankAccountUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<bool>> call() => _repo.deleteBankAccount();
}

@injectable
class CreateInfluencerWithdrawalUseCase {
  const CreateInfluencerWithdrawalUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerWithdrawalEntity>> call({
    required double amount,
    required String correlationId,
    required bool saveAsDefaultBank,
    String? bankName,
    String? accountHolderName,
    String? iban,
  }) => _repo.createWithdrawal(
    amount: amount,
    correlationId: correlationId,
    saveAsDefaultBank: saveAsDefaultBank,
    bankName: bankName,
    accountHolderName: accountHolderName,
    iban: iban,
  );
}

@injectable
class CancelInfluencerWithdrawalUseCase {
  const CancelInfluencerWithdrawalUseCase(this._repo);
  final InfluencerRepository _repo;
  Future<ApiResult<InfluencerWithdrawalEntity>> call(String id) =>
      _repo.cancelWithdrawal(id);
}
