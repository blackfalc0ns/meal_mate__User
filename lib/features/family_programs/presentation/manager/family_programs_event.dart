sealed class FamilyProgramsEvent {
  const FamilyProgramsEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilyProgramsEvent {
  const GetFamilySubscriptionCurrentEvent({this.memberId});

  final String? memberId;
}

class GetFamilyProgramsEvent extends FamilyProgramsEvent {
  const GetFamilyProgramsEvent({this.page = 1, this.pageSize = 10});

  final int page;
  final int pageSize;
}

class LoadMoreFamilyProgramsEvent extends FamilyProgramsEvent {
  const LoadMoreFamilyProgramsEvent({this.pageSize = 10});

  final int pageSize;
}

class SelectFamilyProgramEvent extends FamilyProgramsEvent {
  const SelectFamilyProgramEvent(this.programIndex);

  final int programIndex;
}

class SelectFamilyMemberEvent extends FamilyProgramsEvent {
  const SelectFamilyMemberEvent(this.memberIndex);

  final int memberIndex;
}

class SaveFamilyProgramsEvent extends FamilyProgramsEvent {
  const SaveFamilyProgramsEvent();
}
