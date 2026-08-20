sealed class FamilyPlanEvent {
  const FamilyPlanEvent();
}

class GetFamilyProgramsEvent extends FamilyPlanEvent {
  const GetFamilyProgramsEvent();
}

class SelectFamilyProgramEvent extends FamilyPlanEvent {
  const SelectFamilyProgramEvent(this.programIndex);

  final int programIndex;
}

class GetFamilyBundlesEvent extends FamilyPlanEvent {
  const GetFamilyBundlesEvent(this.programId);

  final String programId;
}

class SelectFamilyBundleEvent extends FamilyPlanEvent {
  const SelectFamilyBundleEvent(this.bundleIndex);

  final int bundleIndex;
}

class GetFamilyDurationsEvent extends FamilyPlanEvent {
  const GetFamilyDurationsEvent({
    required this.programId,
    required this.bundleId,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final bool includeFriday;
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
