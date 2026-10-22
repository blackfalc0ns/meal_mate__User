class CompensationChoiceEntity {
  const CompensationChoiceEntity({
    required this.id,
    required this.status,
    this.selectedAlternativeDate,
  });
  final String id, status;
  final String? selectedAlternativeDate;
}
