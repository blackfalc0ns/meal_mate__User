import 'package:json_annotation/json_annotation.dart';

part 'voice_device_register_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceDeviceRegisterRequestDto {
  const VoiceDeviceRegisterRequestDto({
    required this.installationId,
    required this.platform,
    this.capabilityVersion = 2,
    this.fcmDeviceTokenId,
    this.apnsVoipToken,
  });

  final String installationId;

  /// Backend contract values are the strings `android` or `ios`.
  final String platform;
  final int capabilityVersion;
  final String? fcmDeviceTokenId;
  final String? apnsVoipToken;

  factory VoiceDeviceRegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceDeviceRegisterRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceDeviceRegisterRequestDtoToJson(this);
}
