enum NotificationCategory {
  all,
  subscription,
  meals,
  system,
}

enum NotificationCardIcon {
  mealCloche,
  mealCheck,
  packageCard,
  deliveryTruck,
  offerGift,
  systemRefresh,
}

class NotificationItemEntity {
  final String id;
  final String? eventKey;
  final String? subjectId;
  final String? subscriptionId;
  final String? titleAr;
  final String? titleEn;
  final String? bodyAr;
  final String? bodyEn;
  final String? deepLink;
  final DateTime? createdAtUtc;
  final DateTime? readAtUtc;
  final bool _explicitIsRead;

  final String? _legacyTitle;
  final String? _legacyBody;
  final NotificationCategory _category;
  final NotificationCardIcon _iconType;
  final String? _timeText;
  final bool _isToday;

  const NotificationItemEntity({
    required this.id,
    this.eventKey,
    this.subjectId,
    this.subscriptionId,
    this.titleAr,
    this.titleEn,
    this.bodyAr,
    this.bodyEn,
    this.deepLink,
    this.createdAtUtc,
    this.readAtUtc,
    bool isRead = false,
    String? title,
    String? body,
    this._category = NotificationCategory.all,
    this._iconType = NotificationCardIcon.mealCloche,
    this._timeText,
    this._isToday = false,
  })  : _explicitIsRead = isRead,
        _legacyTitle = title,
        _legacyBody = body;

  bool get isRead => readAtUtc != null || _explicitIsRead;
  String get title => _legacyTitle ?? titleAr ?? titleEn ?? '';
  String get body => _legacyBody ?? bodyAr ?? bodyEn ?? '';
  NotificationCategory get category => _category;
  NotificationCardIcon get iconType => _iconType;
  String get timeText => _timeText ?? '';
  bool get isToday => _isToday;

  NotificationItemEntity copyWith({
    String? id,
    String? eventKey,
    String? subjectId,
    String? subscriptionId,
    String? titleAr,
    String? titleEn,
    String? bodyAr,
    String? bodyEn,
    String? deepLink,
    DateTime? createdAtUtc,
    DateTime? readAtUtc,
    bool? isRead,
    String? title,
    String? body,
    NotificationCategory? category,
    NotificationCardIcon? iconType,
    String? timeText,
    bool? isToday,
  }) {
    return NotificationItemEntity(
      id: id ?? this.id,
      eventKey: eventKey ?? this.eventKey,
      subjectId: subjectId ?? this.subjectId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      bodyAr: bodyAr ?? this.bodyAr,
      bodyEn: bodyEn ?? this.bodyEn,
      deepLink: deepLink ?? this.deepLink,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      readAtUtc: readAtUtc ?? this.readAtUtc,
      isRead: isRead ?? this.isRead,
      title: title ?? _legacyTitle,
      body: body ?? _legacyBody,
      category: category ?? _category,
      iconType: iconType ?? _iconType,
      timeText: timeText ?? _timeText,
      isToday: isToday ?? _isToday,
    );
  }
}
