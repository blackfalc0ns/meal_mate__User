import '../../domain/entities/choose_compensation_request_entity.dart';

sealed class CompensationsEvent {
  const CompensationsEvent();
}

class LoadCompensationsEvent extends CompensationsEvent {
  const LoadCompensationsEvent();
}

class LoadCompensationDatesEvent extends CompensationsEvent {
  const LoadCompensationDatesEvent(this.id);
  final String id;
}

class SelectCompensationDateEvent extends CompensationsEvent {
  const SelectCompensationDateEvent(this.id, this.date);
  final String id, date;
}

class SubmitCompensationChoiceEvent extends CompensationsEvent {
  const SubmitCompensationChoiceEvent(this.id, this.choice);
  final String id;
  final CompensationChoice choice;
}

class CompensationDeadlineReachedEvent extends CompensationsEvent {
  const CompensationDeadlineReachedEvent(this.id);
  final String id;
}
