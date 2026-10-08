import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/payment/payment_attempt.dart';

abstract class PaymentAttemptStore {
  Future<PaymentAttempt?> readForCustomer(String customerId);
  Future<void> save(PaymentAttempt attempt);
  Future<void> removeForCustomer(String customerId);
}

@LazySingleton(as: PaymentAttemptStore)
class PaymentAttemptStoreImpl implements PaymentAttemptStore {
  const PaymentAttemptStoreImpl(this._storage);

  final FlutterSecureStorage _storage;
  static const String _keyPrefix = 'payment_attempt_';

  @override
  Future<PaymentAttempt?> readForCustomer(String customerId) async {
    if (customerId.trim().isEmpty) return null;
    try {
      final raw = await _storage.read(key: '$_keyPrefix$customerId');
      if (raw == null || raw.trim().isEmpty) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final attempt = PaymentAttempt.fromJson(json);
      if (attempt.ownerCustomerId != customerId) {
        await removeForCustomer(customerId);
        return null;
      }
      return attempt;
    } catch (_) {
      // Defensively clear corrupted records
      await removeForCustomer(customerId);
      return null;
    }
  }

  @override
  Future<void> save(PaymentAttempt attempt) async {
    if (attempt.ownerCustomerId.trim().isEmpty) {
      throw ArgumentError('ownerCustomerId must not be empty');
    }
    final raw = jsonEncode(attempt.toJson());
    await _storage.write(
      key: '$_keyPrefix${attempt.ownerCustomerId}',
      value: raw,
    );
  }

  @override
  Future<void> removeForCustomer(String customerId) async {
    if (customerId.trim().isEmpty) return;
    try {
      await _storage.delete(key: '$_keyPrefix$customerId');
    } catch (_) {}
  }
}
