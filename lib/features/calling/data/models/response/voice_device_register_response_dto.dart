import 'package:json_annotation/json_annotation.dart';

part 'voice_device_register_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceDeviceRegisterResponseDto {
  const VoiceDeviceRegisterResponseDto({
    this.deviceSessionId,
    this.controlProof,
    this.expiresAtUtc,
  });

  final String? deviceSessionId;
  final String? controlProof;
  final DateTime? expiresAtUtc;

  factory VoiceDeviceRegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceDeviceRegisterResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceDeviceRegisterResponseDtoToJson(this);
}
