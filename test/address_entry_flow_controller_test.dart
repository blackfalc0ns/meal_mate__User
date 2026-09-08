import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/address_entry_flow_controller.dart';

void main() {
  test('saved address returns to location selection for later editing', () {
    final controller = AddressEntryFlowController();

    controller.showAddressDetails();
    expect(controller.stage, AddressEntryStage.details);

    controller.addressSaved();
    expect(controller.stage, AddressEntryStage.locationSelection);
  });

  test('stale successful action is handled only once', () {
    final tracker = AddressActionSuccessTracker();
    final successfulAction = Object();

    expect(tracker.shouldHandle(successfulAction, isSuccess: true), isTrue);
    expect(tracker.shouldHandle(successfulAction, isSuccess: true), isFalse);
    expect(tracker.shouldHandle(Object(), isSuccess: false), isFalse);
    expect(tracker.shouldHandle(Object(), isSuccess: true), isTrue);
  });
}
