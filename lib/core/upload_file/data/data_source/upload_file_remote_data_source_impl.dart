import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/upload_file/data/data_source/upload_file_remote_data_source.dart';
import 'package:meal_meat_user/core/upload_file/data/models/request/upload_file_request_dto.dart';
import 'package:meal_meat_user/core/upload_file/data/models/response/upload_file_response_dto.dart';

@Injectable(as: UploadFileRemoteDataSource)
class UploadFileRemoteDataSourceImpl implements UploadFileRemoteDataSource {
  UploadFileRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<UploadFileResponseDto> uploadFile(UploadFileRequestDto request) {
    return _apiServices.uploadFile(request.file, request.scope, request.folder);
  }
}
