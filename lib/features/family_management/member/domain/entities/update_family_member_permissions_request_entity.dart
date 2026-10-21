class UpdateFamilyMemberPermissionsRequestEntity {
  const UpdateFamilyMemberPermissionsRequestEntity({
    required this.expectedVersion,
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

  final int expectedVersion;
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
}
