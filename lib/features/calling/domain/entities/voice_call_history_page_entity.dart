import 'voice_call_snapshot_entity.dart';

class VoiceCallHistoryPageEntity {
  const VoiceCallHistoryPageEntity({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  final List<VoiceCallSnapshotEntity> items;
  final int totalCount;
  final int page;
  final int pageSize;
}
