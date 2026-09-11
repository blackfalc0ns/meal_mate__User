import 'package:flutter/foundation.dart';

enum AddressEntryStage { locationSelection, details, coveragePreview }

class AddressEntryFlowController extends ChangeNotifier {
  AddressEntryStage _stage = AddressEntryStage.locationSelection;

  AddressEntryStage get stage => _stage;

  void showAddressDetails() => _setStage(AddressEntryStage.details);

  void showCoveragePreview() => _setStage(AddressEntryStage.coveragePreview);

  void editAddressDetails() => _setStage(AddressEntryStage.details);

  void chooseLocation() => _setStage(AddressEntryStage.locationSelection);

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

class AddressOptimisticAdvanceTracker {
  bool _advanced = false;

  bool advanceOnConfirm() {
    if (_advanced) return false;
    _advanced = true;
    return true;
  }

  bool shouldAdvanceOnSuccess() {
    if (!_advanced) return true;
    _advanced = false;
    return false;
  }

  void reset() => _advanced = false;
}
