/// Contract for tracking advertising placement impressions and clicks.
/// Prevents duplicate events and ensures events are sent with stable identifiers.
abstract class AdvertisingEventTracker {
  /// Track an impression after actual visibility.
  /// Returns `true` if the event was recorded, `false` if duplicate was ignored.
  bool trackImpression({
    required String placementId,
    required String eventId,
  });

  /// Track a click before user navigation.
  /// Returns `true` if the event was recorded, `false` if duplicate was ignored.
  bool trackClick({
    required String placementId,
    required String eventId,
  });

  /// Check whether an event with [eventId] has already been recorded.
  bool hasTracked(String eventId);

  /// Clear tracked events (e.g. on session restart or test cleanup).
  void reset();
}
