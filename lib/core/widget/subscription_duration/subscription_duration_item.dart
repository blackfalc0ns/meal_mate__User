abstract interface class SubscriptionDurationItem {
  bool get isCustom;
  int? get durationDays;
  int? get minDays;
  int? get maxDays;
  int get totalServiceDays;
  String name(String localeName);
}
