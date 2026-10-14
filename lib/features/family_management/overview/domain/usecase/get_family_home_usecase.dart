import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_home_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/repo/family_overview_repository.dart';

@injectable
class GetFamilyHomeUseCase {
  const GetFamilyHomeUseCase(this._repository);

  final FamilyOverviewRepository _repository;

  Future<ApiResult<FamilyHomeEntity>> call({String locale = 'ar'}) {
    return _repository.getFamilyHome(locale: locale);
  }
}
