/// Domain entity for Advertising Placement under Backend Contract v3.1.
enum AdvertisingEventType { impression, click }

class AdvertisingPlacementEntity {
  const AdvertisingPlacementEntity({
    required this.placementId,
    required this.placementKey,
    required this.offerId,
    required this.displayStartsAtUtc,
    required this.displayEndsAtUtc,
    this.titleAr,
    this.titleEn,
    this.imageUrl,
  });

  final String placementId;
  final String placementKey;
  final String offerId;
  final DateTime displayStartsAtUtc;
  final DateTime displayEndsAtUtc;
  final String? titleAr;
  final String? titleEn;
  final String? imageUrl;

  /// Whether this placement is currently active inside the half-open window:
  /// `[displayStartsAtUtc, displayEndsAtUtc)` using authoritative server time.
  bool isVisibleAt(DateTime serverNowUtc) {
    final utc = serverNowUtc.toUtc();
    return !utc.isBefore(displayStartsAtUtc.toUtc()) &&
        utc.isBefore(displayEndsAtUtc.toUtc());
  }
}
