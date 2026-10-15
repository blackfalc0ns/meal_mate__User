class FamilyMemberPermissionsRequestDto {
  const FamilyMemberPermissionsRequestDto({
    this.expectedVersion,
    this.patch = const {},
    this.editDailyMeals,
    this.changeDeliveryTime,
    this.viewProgram,
    this.changeProgram,
    this.editMealsAndDays,
    this.editAddress,
    this.unitExchange,
    this.changePassword,
    this.viewCalendar,
    this.viewInvoices,
    this.selectRestaurant,
    this.confirmMeals,
    this.requestFreeze,
    this.requestRenewal,
    this.requestUpgrade,
    this.cancelSubscription,
    this.viewFamilyCalendars,
    this.viewFamilyPlans,
    this.viewFamilyInvoices,
  });

  final int? expectedVersion;
  final Map<String, bool> patch;
  final bool? editDailyMeals;
  final bool? changeDeliveryTime;
  final bool? viewProgram;
  final bool? changeProgram;
  final bool? editMealsAndDays;
  final bool? editAddress;
  final bool? unitExchange;
  final bool? changePassword;
  final bool? viewCalendar;
  final bool? viewInvoices;
  final bool? selectRestaurant;
  final bool? confirmMeals;
  final bool? requestFreeze;
  final bool? requestRenewal;
  final bool? requestUpgrade;
  final bool? cancelSubscription;
  final bool? viewFamilyCalendars;
  final bool? viewFamilyPlans;
  final bool? viewFamilyInvoices;

  factory FamilyMemberPermissionsRequestDto.fromJson(Map<String, dynamic> json) {
    return FamilyMemberPermissionsRequestDto(
      expectedVersion: (json['expectedVersion'] as num?)?.toInt(),
      editDailyMeals: json['editDailyMeals'] as bool?,
      changeDeliveryTime: json['changeDeliveryTime'] as bool?,
      viewProgram: json['viewProgram'] as bool?,
      changeProgram: json['changeProgram'] as bool?,
      editMealsAndDays: json['editMealsAndDays'] as bool?,
      editAddress: json['editAddress'] as bool?,
      unitExchange: json['unitExchange'] as bool?,
      changePassword: json['changePassword'] as bool?,
      viewCalendar: json['viewCalendar'] as bool?,
      viewInvoices: json['viewInvoices'] as bool?,
      selectRestaurant: json['selectRestaurant'] as bool?,
      confirmMeals: json['confirmMeals'] as bool?,
      requestFreeze: json['requestFreeze'] as bool?,
      requestRenewal: json['requestRenewal'] as bool?,
      requestUpgrade: json['requestUpgrade'] as bool?,
      cancelSubscription: json['cancelSubscription'] as bool?,
      viewFamilyCalendars: json['viewFamilyCalendars'] as bool?,
      viewFamilyPlans: json['viewFamilyPlans'] as bool?,
      viewFamilyInvoices: json['viewFamilyInvoices'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (expectedVersion != null) map['expectedVersion'] = expectedVersion;

    void addIfNonNull(String k, bool? v) {
      if (v != null) {
        map[k] = v;
      }
    }

    addIfNonNull('editDailyMeals', editDailyMeals);
    addIfNonNull('changeDeliveryTime', changeDeliveryTime);
    addIfNonNull('viewProgram', viewProgram);
    addIfNonNull('changeProgram', changeProgram);
    addIfNonNull('editMealsAndDays', editMealsAndDays);
    addIfNonNull('editAddress', editAddress);
    addIfNonNull('unitExchange', unitExchange);
    addIfNonNull('changePassword', changePassword);
    addIfNonNull('viewCalendar', viewCalendar);
    addIfNonNull('viewInvoices', viewInvoices);
    addIfNonNull('selectRestaurant', selectRestaurant);
    addIfNonNull('confirmMeals', confirmMeals);
    addIfNonNull('requestFreeze', requestFreeze);
    addIfNonNull('requestRenewal', requestRenewal);
    addIfNonNull('requestUpgrade', requestUpgrade);
    addIfNonNull('cancelSubscription', cancelSubscription);
    addIfNonNull('viewFamilyCalendars', viewFamilyCalendars);
    addIfNonNull('viewFamilyPlans', viewFamilyPlans);
    addIfNonNull('viewFamilyInvoices', viewFamilyInvoices);

    for (final entry in patch.entries) {
      if (entry.key != 'changeProgram' && entry.key != 'changeDeliveryTime') {
        map[entry.key] = entry.value;
      }
    }

    return map;
  }
}
