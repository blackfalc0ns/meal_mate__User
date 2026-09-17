sealed class FamilyPlanEvent {
  const FamilyPlanEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilyPlanEvent {
  const GetFamilySubscriptionCurrentEvent({this.memberId});

  final String? memberId;
}

class GetFamilyProgramsEvent extends FamilyPlanEvent {
  const GetFamilyProgramsEvent({this.page = 1, this.pageSize = 10});

  final int page;
  final int pageSize;
}

class LoadMoreFamilyProgramsEvent extends FamilyPlanEvent {
  const LoadMoreFamilyProgramsEvent({this.pageSize = 10});

  final int pageSize;
}

class SelectFamilyProgramEvent extends FamilyPlanEvent {
  const SelectFamilyProgramEvent(this.programIndex);

  final int programIndex;
}

class SelectFamilyMemberEvent extends FamilyPlanEvent {
  const SelectFamilyMemberEvent(this.memberIndex);

  final int memberIndex;
}

class SaveFamilyProgramsEvent extends FamilyPlanEvent {
  const SaveFamilyProgramsEvent();
}
