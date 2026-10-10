import 'package:json_annotation/json_annotation.dart';

part 'voice_ice_server_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceIceServerDto {
  const VoiceIceServerDto({
    this.urls,
    this.url,
    this.username,
    this.credential,
    this.expiresAtUtc,
  });

  final List<String>? urls;
  final String? url;
  final String? username;
  final String? credential;
  final DateTime? expiresAtUtc;

  factory VoiceIceServerDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceIceServerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceIceServerDtoToJson(this);
}
