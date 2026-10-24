sealed class VoicePermissionSetupEvent {
  const VoicePermissionSetupEvent();
}

class CheckPermissionEvent extends VoicePermissionSetupEvent {
  const CheckPermissionEvent();
}

class RequestPermissionEvent extends VoicePermissionSetupEvent {
  const RequestPermissionEvent();
}

class DismissPermissionExplainerEvent extends VoicePermissionSetupEvent {
  const DismissPermissionExplainerEvent();
}

class OpenPermissionSettingsEvent extends VoicePermissionSetupEvent {
  const OpenPermissionSettingsEvent();
}
