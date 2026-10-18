import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/features/offers/domain/services/advertising_event_tracker.dart';

@LazySingleton(as: AdvertisingEventTracker)
class AdvertisingEventTrackerImpl implements AdvertisingEventTracker {
  final Set<String> _trackedEventIds = <String>{};

  @override
  bool trackImpression({
    required String placementId,
    required String eventId,
  }) {
    if (_trackedEventIds.contains(eventId)) {
      return false;
    }
    _trackedEventIds.add(eventId);
    // In production with backend telemetry, fire analytics / network request here.
    return true;
  }

  @override
  bool trackClick({
    required String placementId,
    required String eventId,
  }) {
    if (_trackedEventIds.contains(eventId)) {
      return false;
    }
    _trackedEventIds.add(eventId);
    // In production with backend telemetry, fire analytics / network request here.
    return true;
  }

  @override
  bool hasTracked(String eventId) {
    return _trackedEventIds.contains(eventId);
  }

  @override
  void reset() {
    _trackedEventIds.clear();
  }
}
