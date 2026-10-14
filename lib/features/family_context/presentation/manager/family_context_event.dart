sealed class FamilyContextEvent {
  const FamilyContextEvent();
}

class LoadFamilyContextsEvent extends FamilyContextEvent {
  const LoadFamilyContextsEvent();
}

class ClearFamilyContextsEvent extends FamilyContextEvent {
  const ClearFamilyContextsEvent();
}
