import '../../domain/entities/eligible_start_dates_entity.dart';
import '../models/response/eligible_start_dates_response_dto.dart';

extension EligibleStartDatesMapper on EligibleStartDatesResponseDto {
  EligibleStartDatesEntity toEntity({required bool requestedIncludeFriday}) {
    final friday = includeFriday == true && requestedIncludeFriday;
    final dates = <String>{};
    for (final raw in eligibleFirstDeliveryDates ?? const <String>[]) {
      final parsed = DateTime.tryParse(raw);
      if (parsed == null || (!friday && parsed.weekday == DateTime.friday)) {
        continue;
      }
      final canonical =
          '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
      if (canonical == raw) dates.add(raw);
    }
    return EligibleStartDatesEntity(
      dates: List.unmodifiable(dates.toList()..sort()),
      includeFriday: friday,
      operationalLeadHours: operationalLeadHours,
      serverTimeUtc: DateTime.tryParse(serverTimeUtc ?? '')?.toUtc(),
    );
  }
}
