import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_selection_entity.dart';
import 'package:meal_meat_user/features/family_summary/domain/repo/family_summary_repository.dart';

@injectable
class SelectFamilyMemberSummaryUseCase {
  const SelectFamilyMemberSummaryUseCase(this._repository);

  final FamilySummaryRepository _repository;

  Future<ApiResult<FamilySummarySelectionEntity>> call({
    required String memberId,
    required bool subscribeNow,
  }) {
    return _repository.selectFamilyMemberForCheckout(
      memberId: memberId,
      subscribeNow: subscribeNow,
    );
  }
}

typedef SelectFamilyMemberCheckoutUseCase = SelectFamilyMemberSummaryUseCase;
