import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/change_password/data/data_source/change_password_remote_data_source.dart';
import 'package:meal_meat_user/features/change_password/data/mapper/change_customer_password_mapper.dart';
import 'package:meal_meat_user/features/change_password/domain/entities/change_customer_password_request_entity.dart';
import 'package:meal_meat_user/features/change_password/domain/repo/change_password_repository.dart';

@Injectable(as: ChangePasswordRepository)
class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  ChangePasswordRepositoryImpl(this._remoteDataSource);

  final ChangePasswordRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<void>> changeCustomerPassword(
    ChangeCustomerPasswordRequestEntity request,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.changeCustomerPassword(request.toDto());
    });
  }
}
