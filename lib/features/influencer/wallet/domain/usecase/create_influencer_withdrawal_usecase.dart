import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_wallet_entity.dart';
import '../repo/influencer_wallet_repository.dart';

@injectable
class CreateInfluencerWithdrawalUseCase {
  const CreateInfluencerWithdrawalUseCase(this._repo);
  final InfluencerWalletRepository _repo;
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
