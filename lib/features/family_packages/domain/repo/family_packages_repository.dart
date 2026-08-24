import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';

abstract class FamilyPackagesRepository {
  Future<ApiResult<List<FamilySizePackageEntity>>> getFamilySizePackages();
}
