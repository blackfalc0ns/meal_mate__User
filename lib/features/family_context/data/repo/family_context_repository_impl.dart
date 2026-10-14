import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/data/data_source/family_context_remote_data_source.dart';
import 'package:meal_meat_user/features/family_context/data/mapper/family_context_mapper.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/repo/family_context_repository.dart';

@Injectable(as: FamilyContextRepository)
class FamilyContextRepositoryImpl implements FamilyContextRepository {
  const FamilyContextRepositoryImpl(this._remoteDataSource);

  final FamilyContextRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<FamilyContextEntity>>> getMyFamilyContexts() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getMyFamilyContexts();
      return response.map((dto) => dto.toEntity()).toList();
    });
  }
}
