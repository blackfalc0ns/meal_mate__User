sealed class CallingEvent {
  const CallingEvent();
}

class AnswerCallEvent extends CallingEvent {
  const AnswerCallEvent([this.callId]);
  final String? callId;
}

class RejectCallEvent extends CallingEvent {
  const RejectCallEvent([this.callId]);
  final String? callId;
}

class EndCallEvent extends CallingEvent {
  const EndCallEvent([this.callId]);
  final String? callId;
}

class ToggleMuteEvent extends CallingEvent {
  const ToggleMuteEvent();
}

class ToggleSpeakerEvent extends CallingEvent {
  const ToggleSpeakerEvent();
}

class SyncActiveCallEvent extends CallingEvent {
  const SyncActiveCallEvent();
}

class RefreshCallDisplayEvent extends CallingEvent {
  const RefreshCallDisplayEvent({this.callId, this.language});
  final String? callId;
  final String? language;
}
