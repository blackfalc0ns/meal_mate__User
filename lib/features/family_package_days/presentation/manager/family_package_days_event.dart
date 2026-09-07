sealed class FamilyPlanEvent {
  const FamilyPlanEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilyPlanEvent {
  const GetFamilySubscriptionCurrentEvent();
}

class GetFamilyProgramsEvent extends FamilyPlanEvent {
  const GetFamilyProgramsEvent();
}

class GetFamilyBundlesEvent extends FamilyPlanEvent {
  const GetFamilyBundlesEvent(this.programId);

  final String programId;
}

class SelectFamilyBundleEvent extends FamilyPlanEvent {
  const SelectFamilyBundleEvent(this.bundleIndex);

  final int bundleIndex;
}

class SelectFamilyDurationEvent extends FamilyPlanEvent {
  const SelectFamilyDurationEvent(this.durationIndex);

  final int durationIndex;
}

class UpdateFamilyCustomDurationEvent extends FamilyPlanEvent {
  const UpdateFamilyCustomDurationEvent(this.durationDays);

  final int? durationDays;
}

class ToggleFamilyFridayEvent extends FamilyPlanEvent {
  const ToggleFamilyFridayEvent(this.includeFriday);

  final bool includeFriday;
}

class SelectFamilyTierEvent extends FamilyPlanEvent {
  const SelectFamilyTierEvent(this.tierIndex);

  final int tierIndex;
}

class BrowseFamilyTierRestaurantsEvent extends FamilyPlanEvent {
  const BrowseFamilyTierRestaurantsEvent(this.tierIndex);

  final int tierIndex;
}

class CloseFamilyBrowseRestaurantsEvent extends FamilyPlanEvent {
  const CloseFamilyBrowseRestaurantsEvent();
}

class SelectFamilyMemberEvent extends FamilyPlanEvent {
  const SelectFamilyMemberEvent(this.memberIndex);

  final int memberIndex;
}

class SelectFamilyMemberPackageDaysEvent extends FamilyPlanEvent {
  const SelectFamilyMemberPackageDaysEvent(this.memberIndex);

  final int memberIndex;
}

class SaveFamilyMemberPlanEvent extends FamilyPlanEvent {
  const SaveFamilyMemberPlanEvent({
    required this.memberId,
    this.programId,
    this.bundleId,
    this.tier,
    this.durationDays,
    this.includeFriday,
    this.startDate,
  });

  final String memberId;
  final String? programId;
  final String? bundleId;
  final int? tier;
  final int? durationDays;
  final bool? includeFriday;
  final String? startDate;
}
