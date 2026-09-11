import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

@lazySingleton
class FamilyFlowSnapshotStore {
  FamilyFlowCurrentEntity? current;
  int _revision = 0;

  int get revision => _revision;

  void update(FamilyFlowCurrentEntity value) {
    current = value;
    _revision++;
  }

  bool updateIfUnchanged(int expectedRevision, FamilyFlowCurrentEntity value) {
    if (_revision != expectedRevision) return false;
    update(value);
    return true;
  }

  void invalidate() {
    current = null;
    _revision++;
  }
}
