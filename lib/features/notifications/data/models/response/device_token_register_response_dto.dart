import 'package:json_annotation/json_annotation.dart';

part 'device_token_register_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class DeviceTokenRegisterResponseDto {
  const DeviceTokenRegisterResponseDto({this.fcmDeviceTokenId});

  final String? fcmDeviceTokenId;

  factory DeviceTokenRegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenRegisterResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTokenRegisterResponseDtoToJson(this);
}
