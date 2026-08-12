import 'package:dio/dio.dart';

class UploadFileRequestDto {
  const UploadFileRequestDto({
    required this.file,
    required this.scope,
    required this.folder,
  });

  final MultipartFile file;
  final String scope;
  final String folder;
}
