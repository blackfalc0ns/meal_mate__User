abstract interface class SubscriptionDurationItem {
  bool get isCustom;
  int? get durationDays;
  int? get minDays;
  int? get maxDays;
  int get totalServiceDays;
  int get fridayDays;
  String name(String localeName);
}
