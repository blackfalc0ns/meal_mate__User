import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_packages/domain/repo/family_packages_repository.dart';

@injectable
class GetFamilySizePackagesUseCase {
  GetFamilySizePackagesUseCase(this._repository);

  final FamilyPackagesRepository _repository;

  Future<ApiResult<List<FamilySizePackageEntity>>> call() {
    return _repository.getFamilySizePackages();
  }
}
