import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_context/data/data_source/family_context_remote_data_source.dart';
import 'package:meal_meat_user/features/family_context/data/models/response/family_context_response_dto.dart';

@Injectable(as: FamilyContextRemoteDataSource)
class FamilyContextRemoteDataSourceImpl
    implements FamilyContextRemoteDataSource {
  const FamilyContextRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<FamilyContextResponseDto>> getMyFamilyContexts() {
    return _apiServices.getMyFamilyContexts();
  }
}
