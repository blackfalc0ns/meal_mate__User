/// Defines the lifecycle persistence policy for an authenticated session.
enum SessionPersistence {
  /// Session is valid for the current app execution process only.
  /// Cold restart will require re-authentication.
  currentRun,

  /// Session persists across app restarts when Remember Me was selected.
  remembered,
}
