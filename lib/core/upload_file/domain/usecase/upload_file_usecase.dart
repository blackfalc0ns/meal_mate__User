import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_entity.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/core/upload_file/domain/repo/upload_file_repository.dart';

@injectable
class UploadFileUseCase {
  UploadFileUseCase(this._repository);

  final UploadFileRepository _repository;

  Future<ApiResult<UploadFileEntity>> call(UploadFileRequestEntity request) {
    return _repository.uploadFile(request);
  }
}
