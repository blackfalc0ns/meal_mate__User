import 'package:json_annotation/json_annotation.dart';
import 'voice_ice_server_dto.dart';

part 'voice_ice_servers_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceIceServersResponseDto {
  const VoiceIceServersResponseDto({
    this.iceServers,
    this.ttlSeconds,
  });

  final List<VoiceIceServerDto>? iceServers;
  final int? ttlSeconds;

  factory VoiceIceServersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceIceServersResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceIceServersResponseDtoToJson(this);
}
