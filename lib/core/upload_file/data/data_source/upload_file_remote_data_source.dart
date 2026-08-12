import 'package:meal_meat_user/core/upload_file/data/models/request/upload_file_request_dto.dart';
import 'package:meal_meat_user/core/upload_file/data/models/response/upload_file_response_dto.dart';

abstract interface class UploadFileRemoteDataSource {
  Future<UploadFileResponseDto> uploadFile(UploadFileRequestDto request);
}
