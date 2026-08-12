import 'package:json_annotation/json_annotation.dart';

part 'upload_file_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class UploadFileResponseDto {
  const UploadFileResponseDto({
    this.storageKey,
    this.fileName,
    this.contentType,
    this.sizeBytes,
    this.readUrl,
    this.folder,
    this.scope,
  });

  final String? storageKey;
  final String? fileName;
  final String? contentType;
  final int? sizeBytes;
  final String? readUrl;
  final String? folder;
  final String? scope;

  factory UploadFileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UploadFileResponseDtoFromJson(json);
}
