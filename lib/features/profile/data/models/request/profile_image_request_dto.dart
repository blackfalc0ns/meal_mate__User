import 'package:json_annotation/json_annotation.dart';

part 'profile_image_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ProfileImageRequestDto {
  const ProfileImageRequestDto({required this.storageKey});

  final String storageKey;

  Map<String, dynamic> toJson() => _$ProfileImageRequestDtoToJson(this);
}
