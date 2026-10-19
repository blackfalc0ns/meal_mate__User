import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_summary/domain/repo/family_summary_repository.dart';

@injectable
class GetFamilySummaryUseCase {
  GetFamilySummaryUseCase(this._repository);

  final FamilySummaryRepository _repository;

  Future<ApiResult<FamilySummaryEntity>> call({
    String? memberId,
    String? promoCode,
  }) {
    return _repository.getFamilySummary(
      memberId: memberId,
      promoCode: promoCode,
    );
  }
}
