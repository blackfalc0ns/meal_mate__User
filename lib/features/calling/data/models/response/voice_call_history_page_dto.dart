import 'package:json_annotation/json_annotation.dart';
import 'voice_call_snapshot_dto.dart';

part 'voice_call_history_page_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceCallHistoryPageDto {
  const VoiceCallHistoryPageDto({
    this.items,
    this.totalCount,
    this.page,
    this.pageSize,
  });

  final List<VoiceCallSnapshotDto>? items;
  final int? totalCount;
  final int? page;
  final int? pageSize;

  factory VoiceCallHistoryPageDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceCallHistoryPageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceCallHistoryPageDtoToJson(this);
}
