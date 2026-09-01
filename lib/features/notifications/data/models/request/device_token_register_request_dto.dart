import 'package:json_annotation/json_annotation.dart';

part 'device_token_register_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class DeviceTokenRegisterRequestDto {
  const DeviceTokenRegisterRequestDto({
    required this.token,
    required this.platform,
    required this.deviceId,
  });

  final String token;
  final int platform;
  final String deviceId;

  Map<String, dynamic> toJson() => _$DeviceTokenRegisterRequestDtoToJson(this);
}
