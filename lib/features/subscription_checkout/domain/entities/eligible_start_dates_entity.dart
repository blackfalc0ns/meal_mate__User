class EligibleStartDatesEntity {
  const EligibleStartDatesEntity({
    required this.dates,
    required this.includeFriday,
    this.operationalLeadHours,
    this.serverTimeUtc,
  });
  final List<String> dates;
  final bool includeFriday;
  final int? operationalLeadHours;
  final DateTime? serverTimeUtc;
  String? get earliestDate => dates.firstOrNull;
  bool contains(String date) => dates.contains(date);
}
