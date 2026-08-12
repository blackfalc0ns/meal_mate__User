import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/change_password/data/data_source/change_password_remote_data_source.dart';
import 'package:meal_meat_user/features/change_password/data/models/request/change_customer_password_request_dto.dart';

@Injectable(as: ChangePasswordRemoteDataSource)
class ChangePasswordRemoteDataSourceImpl
    implements ChangePasswordRemoteDataSource {
  ChangePasswordRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<void> changeCustomerPassword(
    ChangeCustomerPasswordRequestDto request,
  ) {
    return _apiServices.changeCustomerPassword(request);
  }
}
