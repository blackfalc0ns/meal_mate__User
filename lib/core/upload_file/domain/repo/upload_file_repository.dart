import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_entity.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_request_entity.dart';

abstract interface class UploadFileRepository {
  Future<ApiResult<UploadFileEntity>> uploadFile(
    UploadFileRequestEntity request,
  );
}
