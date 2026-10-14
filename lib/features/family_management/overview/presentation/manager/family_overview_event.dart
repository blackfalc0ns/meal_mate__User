sealed class FamilyOverviewEvent {
  const FamilyOverviewEvent();
}

class LoadFamilyHomeEvent extends FamilyOverviewEvent {
  const LoadFamilyHomeEvent({this.locale = 'ar'});
  final String locale;
}

class LoadFamilyMembersEvent extends FamilyOverviewEvent {
  const LoadFamilyMembersEvent({this.locale = 'ar'});
  final String locale;
}

class SearchFamilyMembersEvent extends FamilyOverviewEvent {
  const SearchFamilyMembersEvent(this.query);
  final String query;
}
