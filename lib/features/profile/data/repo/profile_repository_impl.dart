import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:meal_meat_user/features/profile/data/mapper/customer_profile_mapper.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<CustomerProfileEntity>> getCustomerProfile() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCustomerProfile();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> updateCustomerProfile(
    UpdateCustomerProfileRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateCustomerProfile(request.toDto());
    });
  }

  @override
  Future<ApiResult<void>> updateCustomerProfileImage(
    ProfileImageRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateCustomerProfileImage(request.toDto());
    });
  }

  @override
  Future<ApiResult<void>> deleteCustomerProfileImage() {
    return safeApiCall(() async {
      await _remoteDataSource.deleteCustomerProfileImage();
    });
  }
}
