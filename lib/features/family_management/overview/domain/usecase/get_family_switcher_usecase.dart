import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/repo/family_overview_repository.dart';

class GetFamilySwitcherUseCase {
  const GetFamilySwitcherUseCase(this._repository);

  final FamilyOverviewRepository _repository;

  Future<ApiResult<List<FamilyMemberSummaryEntity>>> call({
    String locale = 'ar',
  }) {
    return _repository.getFamilySwitcher(locale: locale);
  }
}
