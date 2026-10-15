class FamilyMemberPermissionsResponseDto {
  const FamilyMemberPermissionsResponseDto({
    required this.memberId,
    required this.version,
    this.editDailyMeals = false,
    this.changeDeliveryTime = false,
    this.viewProgram = false,
    this.changeProgram = false,
    this.editMealsAndDays = false,
    this.editAddress = false,
    this.unitExchange = false,
    this.changePassword = false,
    this.viewCalendar = false,
    this.viewInvoices = false,
    this.selectRestaurant = false,
    this.confirmMeals = false,
    this.requestFreeze = false,
    this.requestRenewal = false,
    this.requestUpgrade = false,
    this.cancelSubscription = false,
    this.viewFamilyCalendars = false,
    this.viewFamilyPlans = false,
    this.viewFamilyInvoices = false,
    this.groups = const [],
  });

  final String memberId;
  final int version;
  final bool editDailyMeals;
  final bool changeDeliveryTime;
  final bool viewProgram;
  final bool changeProgram;
  final bool editMealsAndDays;
  final bool editAddress;
  final bool unitExchange;
  final bool changePassword;

  final bool viewCalendar;
  final bool viewInvoices;
  final bool selectRestaurant;
  final bool confirmMeals;
  final bool requestFreeze;
  final bool requestRenewal;
  final bool requestUpgrade;
  final bool cancelSubscription;
  final bool viewFamilyCalendars;
  final bool viewFamilyPlans;
  final bool viewFamilyInvoices;

  final List<FamilyPermissionGroupDto> groups;

  Map<String, bool> toValuesMap() => {
    'editDailyMeals': editDailyMeals,
    'changeDeliveryTime': changeDeliveryTime,
    'viewProgram': viewProgram,
    'changeProgram': changeProgram,
    'editMealsAndDays': editMealsAndDays,
    'editAddress': editAddress,
    'unitExchange': unitExchange,
    'changePassword': changePassword,
    'viewCalendar': viewCalendar,
    'viewInvoices': viewInvoices,
    'selectRestaurant': selectRestaurant,
    'confirmMeals': confirmMeals,
    'requestFreeze': requestFreeze,
    'requestRenewal': requestRenewal,
    'requestUpgrade': requestUpgrade,
    'cancelSubscription': cancelSubscription,
    'viewFamilyCalendars': viewFamilyCalendars,
    'viewFamilyPlans': viewFamilyPlans,
    'viewFamilyInvoices': viewFamilyInvoices,
  };

  factory FamilyMemberPermissionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return FamilyMemberPermissionsResponseDto(
      memberId: json['memberId']?.toString() ?? '',
      version: (json['version'] as num?)?.toInt() ?? 1,
      editDailyMeals: json['editDailyMeals'] as bool? ?? false,
      changeDeliveryTime: json['changeDeliveryTime'] as bool? ?? false,
      viewProgram: json['viewProgram'] as bool? ?? false,
      changeProgram: json['changeProgram'] as bool? ?? false,
      editMealsAndDays: json['editMealsAndDays'] as bool? ?? false,
      editAddress: json['editAddress'] as bool? ?? false,
      unitExchange: json['unitExchange'] as bool? ?? false,
      changePassword: json['changePassword'] as bool? ?? false,
      viewCalendar: json['viewCalendar'] as bool? ?? false,
      viewInvoices: json['viewInvoices'] as bool? ?? false,
      selectRestaurant: json['selectRestaurant'] as bool? ?? false,
      confirmMeals: json['confirmMeals'] as bool? ?? false,
      requestFreeze: json['requestFreeze'] as bool? ?? false,
      requestRenewal: json['requestRenewal'] as bool? ?? false,
      requestUpgrade: json['requestUpgrade'] as bool? ?? false,
      cancelSubscription: json['cancelSubscription'] as bool? ?? false,
      viewFamilyCalendars: json['viewFamilyCalendars'] as bool? ?? false,
      viewFamilyPlans: json['viewFamilyPlans'] as bool? ?? false,
      viewFamilyInvoices: json['viewFamilyInvoices'] as bool? ?? false,
      groups:
          (json['groups'] as List<dynamic>?)
              ?.map(
                (e) => FamilyPermissionGroupDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class FamilyPermissionGroupDto {
  const FamilyPermissionGroupDto({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    this.permissions = const [],
  });

  final String code;
  final String labelAr;
  final String labelEn;
  final List<FamilyPermissionItemDto> permissions;

  factory FamilyPermissionGroupDto.fromJson(Map<String, dynamic> json) {
    return FamilyPermissionGroupDto(
      code: json['code']?.toString() ?? '',
      labelAr: json['labelAr']?.toString() ?? json['label']?.toString() ?? '',
      labelEn: json['labelEn']?.toString() ?? json['label']?.toString() ?? '',
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map(
                (e) =>
                    FamilyPermissionItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}

class FamilyPermissionItemDto {
  const FamilyPermissionItemDto({
    required this.key,
    required this.labelAr,
    required this.labelEn,
    required this.value,
    this.descriptionAr = '',
    this.descriptionEn = '',
    this.isSupported = true,
    this.isManagerConfigurable = true,
    this.requiredPermissions = const [],
  });

  final String key;
  final String labelAr;
  final String labelEn;
  final bool value;
  final String descriptionAr;
  final String descriptionEn;
  final bool isSupported;
  final bool isManagerConfigurable;
  final List<String> requiredPermissions;

  String localizedLabel(bool isArabic) {
    if (isArabic) {
      final ar = labelAr.trim();
      if (ar.isNotEmpty) return ar;
      final en = labelEn.trim();
      if (en.isNotEmpty) return en;
      return key;
    }
    final en = labelEn.trim();
    if (en.isNotEmpty) return en;
    final ar = labelAr.trim();
    if (ar.isNotEmpty) return ar;
    return key;
  }

  String localizedDescription(bool isArabic) {
    if (isArabic) {
      final ar = descriptionAr.trim();
      if (ar.isNotEmpty) return ar;
      return descriptionEn.trim();
    }
    final en = descriptionEn.trim();
    if (en.isNotEmpty) return en;
    return descriptionAr.trim();
  }

  factory FamilyPermissionItemDto.fromJson(Map<String, dynamic> json) {
    return FamilyPermissionItemDto(
      key: json['key']?.toString() ?? '',
      labelAr: json['labelAr']?.toString() ?? json['label']?.toString() ?? '',
      labelEn: json['labelEn']?.toString() ?? json['label']?.toString() ?? '',
      descriptionAr: json['descriptionAr']?.toString() ?? json['description']?.toString() ?? '',
      descriptionEn: json['descriptionEn']?.toString() ?? json['description']?.toString() ?? '',
      value: json['value'] as bool? ?? false,
      isSupported: json['isSupported'] as bool? ?? true,
      isManagerConfigurable: json['isManagerConfigurable'] as bool? ?? true,
      requiredPermissions: (json['requiredPermissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
