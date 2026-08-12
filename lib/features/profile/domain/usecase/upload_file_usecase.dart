import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@injectable
class UploadFileUseCase {
  UploadFileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ApiResult<UploadFileEntity>> call(UploadFileRequestEntity request) {
    return _repository.uploadFile(request);
  }
}
