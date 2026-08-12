import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/upload_file/data/data_source/upload_file_remote_data_source.dart';
import 'package:meal_meat_user/core/upload_file/data/mapper/upload_file_mapper.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_entity.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/core/upload_file/domain/repo/upload_file_repository.dart';

@Injectable(as: UploadFileRepository)
class UploadFileRepositoryImpl implements UploadFileRepository {
  UploadFileRepositoryImpl(this._remoteDataSource);

  final UploadFileRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<UploadFileEntity>> uploadFile(
    UploadFileRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.uploadFile(
        await request.toDto(),
      );
      return response.toEntity();
    });
  }
}
