class UpdateFamilyMemberPermissionsRequestDto {
  const UpdateFamilyMemberPermissionsRequestDto({
    required this.expectedVersion,
    required this.editDailyMeals,
    required this.changeDeliveryTime,
    required this.viewProgram,
    required this.changeProgram,
    required this.editMealsAndDays,
    required this.editAddress,
    required this.unitExchange,
    required this.changePassword,
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

  final int expectedVersion;
  final bool editDailyMeals;
  final bool changeDeliveryTime;
  final bool viewProgram;
  final bool changeProgram;
  final bool editMealsAndDays;
  final bool editAddress;
  final bool unitExchange;
  final bool changePassword;

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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'expectedVersion': expectedVersion,
      'editDailyMeals': editDailyMeals,
      'changeDeliveryTime': changeDeliveryTime,
      'viewProgram': viewProgram,
      'changeProgram': changeProgram,
      'editMealsAndDays': editMealsAndDays,
      'editAddress': editAddress,
      'unitExchange': unitExchange,
      'changePassword': changePassword,
    };
    if (viewCalendar != null) map['viewCalendar'] = viewCalendar;
    if (viewInvoices != null) map['viewInvoices'] = viewInvoices;
    if (selectRestaurant != null) map['selectRestaurant'] = selectRestaurant;
    if (confirmMeals != null) map['confirmMeals'] = confirmMeals;
    if (requestFreeze != null) map['requestFreeze'] = requestFreeze;
    if (requestRenewal != null) map['requestRenewal'] = requestRenewal;
    if (requestUpgrade != null) map['requestUpgrade'] = requestUpgrade;
    if (cancelSubscription != null) map['cancelSubscription'] = cancelSubscription;
    if (viewFamilyCalendars != null) map['viewFamilyCalendars'] = viewFamilyCalendars;
    if (viewFamilyPlans != null) map['viewFamilyPlans'] = viewFamilyPlans;
    if (viewFamilyInvoices != null) map['viewFamilyInvoices'] = viewFamilyInvoices;
    return map;
  }
}
