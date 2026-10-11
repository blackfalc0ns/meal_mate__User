import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/address/domain/contracts/address_editor_operations.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/customer_address_editor_operations.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_address_editor_operations.dart';

void main() {
  group('AddressEditorOperations tests', () {
    const dummyRequest = CustomerAddressRequestEntity(
      label: 'Home',
      addressLine: 'Kuwait City',
      latitude: 29.3,
      longitude: 48.0,
      isDefault: false,
      notifyOnDelivery: false,
    );

    const dummyAddress = CustomerAddressEntity(
      addressId: 'addr-1',
      label: 'Home',
      addressLine: 'Kuwait City',
      isDefault: false,
      notifyOnDelivery: false,
    );

    const dummyPreview = AddressCoveragePreviewEntity(
      canSetAsDefault: true,
      isCurrentSubscriptionRestaurantCovered: true,
      hasActiveSubscription: true,
      servingRestaurants: [],
    );

    test(
      'CustomerAddressEditorOperations supports add, update, setDefault and delegates correctly',
      () async {
        var previewNewCalled = false;
        var previewExistingCalled = false;
        var addCalled = false;
        var updateCalled = false;
        var setDefaultCalled = false;

        final ops = CustomerAddressEditorOperations(
          previewNewAddressCoverage: (req, {page, pageSize}) async {
            previewNewCalled = true;
            return const ApiSuccessResult(data: dummyPreview);
          },
          previewExistingAddressCoverage: (id, {page, pageSize}) async {
            previewExistingCalled = true;
            return const ApiSuccessResult(data: dummyPreview);
          },
          addCustomerAddress: (req) async {
            addCalled = true;
            return const ApiSuccessResult(data: dummyAddress);
          },
          updateCustomerAddress: (id, req) async {
            updateCalled = true;
            return const ApiSuccessResult(data: dummyAddress);
          },
          confirmSetDefaultAddress: (id) async {
            setDefaultCalled = true;
            return const ApiSuccessResult(data: dummyAddress);
          },
        );

        expect(
          ops.supportedActions,
          containsAll([
            AddressEditorAction.add,
            AddressEditorAction.update,
            AddressEditorAction.setDefault,
          ]),
        );

        final prevNewRes = await ops.previewNew(dummyRequest);
        expect(prevNewRes.isSuccess, isTrue);
        expect(previewNewCalled, isTrue);

        final prevExistRes = await ops.previewExisting('addr-1');
        expect(prevExistRes.isSuccess, isTrue);
        expect(previewExistingCalled, isTrue);

        final addRes = await ops.add(dummyRequest);
        expect(addRes.isSuccess, isTrue);
        expect(addCalled, isTrue);

        final updateRes = await ops.update('addr-1', dummyRequest);
        expect(updateRes.isSuccess, isTrue);
        expect(updateCalled, isTrue);

        final setDefaultRes = await ops.setDefault('addr-1');
        expect(setDefaultRes.isSuccess, isTrue);
        expect(setDefaultCalled, isTrue);
      },
    );

    test(
      'FamilyAddressEditorOperations delegates with memberId and rejects unsupported actions without fallback',
      () async {
        String? previewMemberId;
        String? addMemberId;

        final ops = FamilyAddressEditorOperations(
          memberId: 'member-123',
          previewFamilyMemberAddress: (mId, req, {page, pageSize}) async {
            previewMemberId = mId;
            return const ApiSuccessResult(data: dummyPreview);
          },
          addFamilyMemberAddress: (mId, req) async {
            addMemberId = mId;
            return const ApiSuccessResult(data: dummyAddress);
          },
        );

        expect(ops.supportedActions, equals({AddressEditorAction.add}));

        final previewRes = await ops.previewNew(dummyRequest);
        expect(previewRes.isSuccess, isTrue);
        expect(previewMemberId, 'member-123');

        final addRes = await ops.add(dummyRequest);
        expect(addRes.isSuccess, isTrue);
        expect(addMemberId, 'member-123');

        // Unsupported operations MUST return failure and NOT call any fallback
        final updateRes = await ops.update('addr-1', dummyRequest);
        expect(updateRes.isError, isTrue);

        final setDefaultRes = await ops.setDefault('addr-1');
        expect(setDefaultRes.isError, isTrue);

        final prevExistingRes = await ops.previewExisting('addr-1');
        expect(prevExistingRes.isError, isTrue);
      },
    );
  });
}
