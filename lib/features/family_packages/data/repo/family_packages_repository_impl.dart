import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_packages/data/data_source/family_packages_remote_data_source.dart';
import 'package:meal_meat_user/features/family_packages/data/mapper/family_size_package_mapper.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_packages/domain/repo/family_packages_repository.dart';

@Injectable(as: FamilyPackagesRepository)
class FamilyPackagesRepositoryImpl implements FamilyPackagesRepository {
  FamilyPackagesRepositoryImpl(this._remoteDataSource);

  final FamilyPackagesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<FamilySizePackageEntity>>> getFamilySizePackages() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilySizePackages();
      return response.map((package) => package.toEntity()).toList();
    });
  }
}
