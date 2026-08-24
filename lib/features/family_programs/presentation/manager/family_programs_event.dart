sealed class FamilyPlanEvent {
  const FamilyPlanEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilyPlanEvent {
  const GetFamilySubscriptionCurrentEvent();
}

class GetFamilyProgramsEvent extends FamilyPlanEvent {
  const GetFamilyProgramsEvent();
}

class SelectFamilyProgramEvent extends FamilyPlanEvent {
  const SelectFamilyProgramEvent(this.programIndex);

  final int programIndex;
}

class SelectFamilyMemberEvent extends FamilyPlanEvent {
  const SelectFamilyMemberEvent(this.memberIndex);

  final int memberIndex;
}
