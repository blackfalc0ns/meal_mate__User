import 'package:json_annotation/json_annotation.dart';

part 'voice_candidate_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceCandidateRequestDto {
  const VoiceCandidateRequestDto({
    required this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
    this.usernameFragment,
  });

  final String candidate;
  final String? sdpMid;
  final int? sdpMLineIndex;
  final String? usernameFragment;

  factory VoiceCandidateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceCandidateRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceCandidateRequestDtoToJson(this);
}
