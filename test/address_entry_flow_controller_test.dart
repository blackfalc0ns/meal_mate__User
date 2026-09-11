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

  test('coverage preview collapses details before final confirmation', () {
    final controller = AddressEntryFlowController();

    controller.showAddressDetails();
    controller.showCoveragePreview();

    expect(controller.stage, AddressEntryStage.coveragePreview);

    controller.editAddressDetails();
    expect(controller.stage, AddressEntryStage.details);
  });

  test('dismissing details returns to location selection', () {
    final controller = AddressEntryFlowController();

    controller.showAddressDetails();
    controller.chooseLocation();

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

  test(
    'optimistic address advance is immediate and not repeated on success',
    () {
      final tracker = AddressOptimisticAdvanceTracker();

      expect(tracker.advanceOnConfirm(), isTrue);
      expect(tracker.shouldAdvanceOnSuccess(), isFalse);

      tracker.reset();
      expect(tracker.shouldAdvanceOnSuccess(), isTrue);
    },
  );
}
