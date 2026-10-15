import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/payment/payment_attempt.dart';
import 'package:meal_meat_user/core/payment/payment_attempt_store.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';

class _InMemoryAttemptStore implements PaymentAttemptStore {
  PaymentAttempt? stored;

  @override
  Future<PaymentAttempt?> readForCustomer(String customerId) async => stored;

  @override
  Future<void> save(PaymentAttempt attempt) async {
    stored = attempt;
  }

  @override
  Future<void> removeForCustomer(String customerId) async {
    stored = null;
  }
}

void main() {
  group('Family Payment Lifecycle, Isolation, and Verification Tests', () {
    test(
      'PaymentAttempt carries family flowType, batchId, batchVersion, and idempotencyKey',
      () {
        final attempt = PaymentAttempt(
          ownerCustomerId: 'cust-1',
          subscriptionId: '',
          paymentId: 'pay-fam-123',
          createdAtUtc: DateTime.utc(2026, 10, 15, 12, 0),
          flowType: 'family',
          batchId: 'batch-abc',
          batchVersion: 2,
          idempotencyKey: 'fam-idemp-999',
          state: 'redirected',
        );

        expect(attempt.isFamily, isTrue);
        expect(attempt.batchId, 'batch-abc');
        expect(attempt.batchVersion, 2);
        expect(attempt.idempotencyKey, 'fam-idemp-999');

        final json = attempt.toJson();
        expect(json['flowType'], 'family');
        expect(json['batchId'], 'batch-abc');
        expect(json['batchVersion'], 2);
        expect(json['idempotencyKey'], 'fam-idemp-999');
        expect(json['state'], 'redirected');

        final restored = PaymentAttempt.fromJson(json);
        expect(restored.isFamily, isTrue);
        expect(restored.batchId, 'batch-abc');
        expect(restored.batchVersion, 2);
        expect(restored.idempotencyKey, 'fam-idemp-999');
        expect(restored.state, 'redirected');
      },
    );

    test('PaymentWebViewArgs carries family flag and batch metadata', () {
      final checkout = PaymentCheckoutEntity.recovery(
        subscriptionId: '',
        paymentId: 'pay-123',
      );
      final args = PaymentWebViewArgs(
        checkout: checkout,
        flowType: 'family',
        batchId: 'batch-xyz',
        batchVersion: 4,
      );

      expect(args.isFamily, isTrue);
      expect(args.batchId, 'batch-xyz');
      expect(args.batchVersion, 4);
    });

    test('PaymentSuccessArgs carries family flag and summary metadata', () {
      const args = PaymentSuccessArgs(
        subscriptionId: 'sub-fam-1',
        packageName: 'Family Plan',
        isFamily: true,
        familyName: 'Al-Ahmad Family',
        memberCount: 4,
      );

      expect(args.isFamily, isTrue);
      expect(args.familyName, 'Al-Ahmad Family');
      expect(args.memberCount, 4);
    });

    test(
      'PaymentAttempt store persists and removes family attempts cleanly',
      () async {
        final store = _InMemoryAttemptStore();
        final attempt = PaymentAttempt(
          ownerCustomerId: 'user-family-1',
          subscriptionId: '',
          paymentId: 'pay-fam-777',
          createdAtUtc: DateTime.utc(2026, 10, 15, 10, 0),
          flowType: 'family',
          batchId: 'batch-001',
          batchVersion: 1,
        );

        await store.save(attempt);
        final read = await store.readForCustomer('user-family-1');
        expect(read?.isFamily, isTrue);
        expect(read?.batchId, 'batch-001');

        await store.removeForCustomer('user-family-1');
        final cleared = await store.readForCustomer('user-family-1');
        expect(cleared, isNull);
      },
    );

    test(
      'Post-activation cleanup clears converted draft markers and invalidates snapshot store',
      () {
        final snapshotStore = FamilyFlowSnapshotStore();
        snapshotStore.update(
          const FamilyFlowCurrentEntity(
            familyGroupId: 'grp-active',
            name: 'Active Family',
          ),
        );
        FamilyConversionDraftSession.markConvertedFamilyDraft();

        expect(snapshotStore.current, isNotNull);
        expect(FamilyConversionDraftSession.isConvertedFamilyDraft, isTrue);

        // Perform cleanup
        FamilyConversionDraftSession.clearConvertedFamilyDraft();
        snapshotStore.invalidate();

        expect(snapshotStore.current, isNull);
        expect(FamilyConversionDraftSession.isConvertedFamilyDraft, isFalse);
      },
    );
  });
}
