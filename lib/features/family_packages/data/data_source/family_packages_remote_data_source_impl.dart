import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_packages/data/data_source/family_packages_remote_data_source.dart';
import 'package:meal_meat_user/features/family_packages/data/models/response/family_size_package_response_dto.dart';

@Injectable(as: FamilyPackagesRemoteDataSource)
class FamilyPackagesRemoteDataSourceImpl
    implements FamilyPackagesRemoteDataSource {
  FamilyPackagesRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<FamilySizePackageResponseDto>> getFamilySizePackages() {
    return _apiServices.getFamilySizePackages();
  }
}
