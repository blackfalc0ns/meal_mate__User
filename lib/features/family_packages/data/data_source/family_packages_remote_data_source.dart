import 'package:meal_meat_user/features/family_packages/data/models/response/family_size_package_response_dto.dart';

abstract class FamilyPackagesRemoteDataSource {
  Future<List<FamilySizePackageResponseDto>> getFamilySizePackages();
}
