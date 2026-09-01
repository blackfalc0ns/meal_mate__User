import 'package:json_annotation/json_annotation.dart';

part 'device_token_unregister_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class DeviceTokenUnregisterRequestDto {
  const DeviceTokenUnregisterRequestDto({required this.token});

  final String token;

  Map<String, dynamic> toJson() =>
      _$DeviceTokenUnregisterRequestDtoToJson(this);
}
