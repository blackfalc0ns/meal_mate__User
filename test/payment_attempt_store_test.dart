import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/payment/payment_attempt.dart';
import 'package:meal_meat_user/core/payment/payment_attempt_store.dart';

class _FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _data[key];
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _data.remove(key);
  }
}

void main() {
  late _FakeSecureStorage storage;
  late PaymentAttemptStore store;

  setUp(() {
    storage = _FakeSecureStorage();
    store = PaymentAttemptStoreImpl(storage);
  });

  group('PaymentAttemptStore Tests', () {
    test('roundtrip save and read succeeds for customer', () async {
      final attempt = PaymentAttempt(
        ownerCustomerId: 'user-123',
        subscriptionId: 'sub-456',
        paymentId: 'pz-track-789',
        createdAtUtc: DateTime.utc(2026, 10, 8, 12, 0),
        reviewRequired: true,
        lastPresentedFinalStatus: 'PendingPayment',
      );

      await store.save(attempt);
      final read = await store.readForCustomer('user-123');

      expect(read, isNotNull);
      expect(read!.ownerCustomerId, 'user-123');
      expect(read.subscriptionId, 'sub-456');
      expect(read.paymentId, 'pz-track-789');
      expect(read.reviewRequired, isTrue);
      expect(read.lastPresentedFinalStatus, 'PendingPayment');
    });

    test('corrupt record in storage is cleared and returns null', () async {
      await storage.write(
        key: 'payment_attempt_user-123',
        value: '{invalid_json...',
      );

      final read = await store.readForCustomer('user-123');
      expect(read, isNull);

      final storageValue = await storage.read(key: 'payment_attempt_user-123');
      expect(storageValue, isNull);
    });

    test(
      'wrong customer read returns null and does not return other data',
      () async {
        final attempt = PaymentAttempt(
          ownerCustomerId: 'user-AAA',
          subscriptionId: 'sub-AAA',
          paymentId: 'pz-AAA',
          createdAtUtc: DateTime.utc(2026, 10, 8, 12, 0),
        );

        await store.save(attempt);

        final readOther = await store.readForCustomer('user-BBB');
        expect(readOther, isNull);
      },
    );

    test(
      'removeForCustomer clears attempt on logout or account switch',
      () async {
        final attempt = PaymentAttempt(
          ownerCustomerId: 'user-123',
          subscriptionId: 'sub-456',
          paymentId: 'pz-track-789',
          createdAtUtc: DateTime.utc(2026, 10, 8, 12, 0),
        );

        await store.save(attempt);
        expect(await store.readForCustomer('user-123'), isNotNull);

        await store.removeForCustomer('user-123');
        expect(await store.readForCustomer('user-123'), isNull);
      },
    );

    test('PaymentAttempt rejects payload missing required IDs', () {
      expect(
        () => PaymentAttempt.fromJson({
          'schemaVersion': 1,
          'ownerCustomerId': '',
          'subscriptionId': 'sub-1',
          'paymentId': 'pz-1',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
