import 'package:dio/dio.dart';
import 'package:meal_meat_user/core/upload_file/data/models/request/upload_file_request_dto.dart';
import 'package:meal_meat_user/core/upload_file/data/models/response/upload_file_response_dto.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_entity.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_request_entity.dart';

extension UploadFileRequestEntityMapper on UploadFileRequestEntity {
  Future<UploadFileRequestDto> toDto() async {
    return UploadFileRequestDto(
      file: await MultipartFile.fromFile(filePath, filename: _fileName),
      scope: scope,
      folder: folder,
    );
  }

  String get _fileName {
    final normalized = filePath.replaceAll('\\', '/');
    return normalized.split('/').last;
  }
}

extension UploadFileResponseDtoMapper on UploadFileResponseDto {
  UploadFileEntity toEntity() {
    return UploadFileEntity(
      storageKey: storageKey ?? '',
      fileName: fileName ?? '',
      contentType: contentType ?? '',
      sizeBytes: sizeBytes ?? 0,
      readUrl: readUrl ?? '',
      folder: folder ?? '',
      scope: scope ?? '',
    );
  }
}
