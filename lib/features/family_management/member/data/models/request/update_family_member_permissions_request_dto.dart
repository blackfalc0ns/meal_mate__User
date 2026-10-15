class UpdateFamilyMemberPermissionsRequestDto {
  const UpdateFamilyMemberPermissionsRequestDto({
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'expectedVersion': expectedVersion,
    };

    void addIfNonNull(String k, bool? v) {
      if (v != null && k != 'changeProgram' && k != 'changeDeliveryTime') {
        map[k] = v;
      }
    }

    addIfNonNull('editDailyMeals', editDailyMeals);
    addIfNonNull('viewProgram', viewProgram);
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
