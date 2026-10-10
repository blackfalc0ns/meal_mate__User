import 'package:json_annotation/json_annotation.dart';

part 'voice_sdp_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceSdpRequestDto {
  const VoiceSdpRequestDto({
    required this.type,
    required this.sdp,
  });

  final String type;
  final String sdp;

  factory VoiceSdpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceSdpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceSdpRequestDtoToJson(this);
}
