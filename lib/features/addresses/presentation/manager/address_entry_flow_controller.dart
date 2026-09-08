import 'package:flutter/foundation.dart';

enum AddressEntryStage { locationSelection, details }

class AddressEntryFlowController extends ChangeNotifier {
  AddressEntryStage _stage = AddressEntryStage.locationSelection;

  AddressEntryStage get stage => _stage;

  void showAddressDetails() => _setStage(AddressEntryStage.details);

  void addressSaved() => _setStage(AddressEntryStage.locationSelection);

  void _setStage(AddressEntryStage stage) {
    if (_stage == stage) return;
    _stage = stage;
    notifyListeners();
  }
}

class AddressActionSuccessTracker {
  Object? _handledAction;

  bool shouldHandle(Object action, {required bool isSuccess}) {
    if (!isSuccess || identical(_handledAction, action)) return false;
    _handledAction = action;
    return true;
  }
}
