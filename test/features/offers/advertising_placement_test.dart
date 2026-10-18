import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/offers/data/services/advertising_event_tracker_impl.dart';
import 'package:meal_meat_user/features/offers/domain/entities/advertising_placement_entity.dart';

void main() {
  group('AdvertisingPlacementEntity', () {
    final startsAt = DateTime.utc(2026, 10, 10, 12, 0, 0);
    final endsAt = DateTime.utc(2026, 10, 15, 12, 0, 0);

    final placement = AdvertisingPlacementEntity(
      placementId: 'place-101',
      placementKey: 'offers_hub_banner',
      offerId: 'offer-55',
      displayStartsAtUtc: startsAt,
      displayEndsAtUtc: endsAt,
      titleAr: 'عرض مميز',
      titleEn: 'Special Offer',
    );

    test('is false before displayStartsAtUtc', () {
      final beforeTime = DateTime.utc(2026, 10, 10, 11, 59, 59);
      expect(placement.isVisibleAt(beforeTime), isFalse);
    });

    test('is true exactly at displayStartsAtUtc (inclusive start)', () {
      expect(placement.isVisibleAt(startsAt), isTrue);
    });

    test('is true within the window [displayStartsAtUtc, displayEndsAtUtc)', () {
      final middleTime = DateTime.utc(2026, 10, 12, 0, 0, 0);
      expect(placement.isVisibleAt(middleTime), isTrue);
    });

    test('is false exactly at displayEndsAtUtc (exclusive end)', () {
      expect(placement.isVisibleAt(endsAt), isFalse);
    });

    test('is false after displayEndsAtUtc', () {
      final afterTime = DateTime.utc(2026, 10, 16, 0, 0, 0);
      expect(placement.isVisibleAt(afterTime), isFalse);
    });
  });

  group('AdvertisingEventTracker', () {
    late AdvertisingEventTrackerImpl tracker;

    setUp(() {
      tracker = AdvertisingEventTrackerImpl();
    });

    test('records first impression and ignores duplicates', () {
      const placementId = 'place-101';
      const eventId = 'imp-101-session-1';

      final firstResult = tracker.trackImpression(
        placementId: placementId,
        eventId: eventId,
      );
      expect(firstResult, isTrue);
      expect(tracker.hasTracked(eventId), isTrue);

      final secondResult = tracker.trackImpression(
        placementId: placementId,
        eventId: eventId,
      );
      expect(secondResult, isFalse);
    });

    test('records first click and ignores duplicates', () {
      const placementId = 'place-101';
      const eventId = 'click-101-session-1';

      final firstResult = tracker.trackClick(
        placementId: placementId,
        eventId: eventId,
      );
      expect(firstResult, isTrue);
      expect(tracker.hasTracked(eventId), isTrue);

      final secondResult = tracker.trackClick(
        placementId: placementId,
        eventId: eventId,
      );
      expect(secondResult, isFalse);
    });

    test('reset clears tracked events', () {
      tracker.trackImpression(placementId: 'p1', eventId: 'e1');
      expect(tracker.hasTracked('e1'), isTrue);

      tracker.reset();
      expect(tracker.hasTracked('e1'), isFalse);
      expect(tracker.trackImpression(placementId: 'p1', eventId: 'e1'), isTrue);
    });
  });
}
