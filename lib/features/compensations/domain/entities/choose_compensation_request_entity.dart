enum CompensationChoice { cashRefund, alternativeDay }

class ChooseCompensationRequestEntity {
  const ChooseCompensationRequestEntity({
    required this.compensationId,
    required this.choice,
    this.targetDate,
  });
  final String compensationId;
  final CompensationChoice choice;
  final String? targetDate;
}
