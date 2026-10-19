import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/validate_discount_result_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class ValidateDiscountUseCase {
  const ValidateDiscountUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<ValidateDiscountResultEntity>> call({
    required String code,
    dynamic programId,
    dynamic bundleId,
  }) {
    return _repository.validateDiscount(
      code: code,
      programId: programId,
      bundleId: bundleId,
    );
  }
}
