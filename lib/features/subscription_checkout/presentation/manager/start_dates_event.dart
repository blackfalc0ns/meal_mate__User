sealed class StartDatesEvent {
  const StartDatesEvent();
}

class LoadStartDatesEvent extends StartDatesEvent {
  const LoadStartDatesEvent({required this.includeFriday});
  final bool includeFriday;
}
