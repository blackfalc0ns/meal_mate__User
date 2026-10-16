sealed class FamilyPackageDaysEvent {
  const FamilyPackageDaysEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilyPackageDaysEvent {
  const GetFamilySubscriptionCurrentEvent({this.memberId});

  final String? memberId;
}

class GetFamilyProgramsEvent extends FamilyPackageDaysEvent {
  const GetFamilyProgramsEvent();
}

class GetFamilyBundlesEvent extends FamilyPackageDaysEvent {
  const GetFamilyBundlesEvent(this.programId);

  final String programId;
}

class SelectFamilyBundleEvent extends FamilyPackageDaysEvent {
  const SelectFamilyBundleEvent(this.bundleIndex);

  final int bundleIndex;
}

class SelectFamilyDurationEvent extends FamilyPackageDaysEvent {
  const SelectFamilyDurationEvent(this.durationIndex);

  final int durationIndex;
}

class UpdateFamilyCustomDurationEvent extends FamilyPackageDaysEvent {
  const UpdateFamilyCustomDurationEvent(this.durationDays);

  final int? durationDays;
}

class ToggleFamilyFridayEvent extends FamilyPackageDaysEvent {
  const ToggleFamilyFridayEvent(this.includeFriday);

  final bool includeFriday;
}

class SelectFamilyTierEvent extends FamilyPackageDaysEvent {
  const SelectFamilyTierEvent(this.tierIndex);

  final int tierIndex;
}

class BrowseFamilyTierRestaurantsEvent extends FamilyPackageDaysEvent {
  const BrowseFamilyTierRestaurantsEvent(this.tierIndex);

  final int tierIndex;
}

class CloseFamilyBrowseRestaurantsEvent extends FamilyPackageDaysEvent {
  const CloseFamilyBrowseRestaurantsEvent();
}

class SelectFamilyMemberEvent extends FamilyPackageDaysEvent {
  const SelectFamilyMemberEvent(this.memberIndex);

  final int memberIndex;
}

class SelectFamilyMemberPackageDaysEvent extends FamilyPackageDaysEvent {
  const SelectFamilyMemberPackageDaysEvent(this.memberIndex);

  final int memberIndex;
}

class ClearFamilyMemberPlanEvent extends FamilyPackageDaysEvent {
  const ClearFamilyMemberPlanEvent(this.memberId);

  final String memberId;
}

class SaveFamilyMemberPlanEvent extends FamilyPackageDaysEvent {
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
