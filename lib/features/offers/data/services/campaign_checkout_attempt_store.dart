import 'dart:convert';
import 'dart:math';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/features/offers/data/models/request/create_campaign_checkout_session_request_dto.dart';

@injectable
class CampaignCheckoutAttemptStore {
  const CampaignCheckoutAttemptStore(this._prefs);
  final SharedPrefHelper _prefs;
  Future<CreateCampaignCheckoutSessionRequestDto?> readPending(
    String customerId,
  ) async {
    final raw = _prefs.getData(key: 'campaign_checkout_pending_$customerId');
    if (raw is! String) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    if (data['customerId'] != customerId) {
      throw StateError('Campaign checkout owner mismatch');
    }
    return CreateCampaignCheckoutSessionRequestDto(
      campaignId: data['campaignId'] as String,
      bundleId: data['bundleId'] as String,
      customerId: customerId,
      durationDays: data['durationDays'] as int,
      quoteId: data['quoteId'] as String,
      idempotencyKey: data['idempotencyKey'] as String,
    );
  }

  Future<double?> readExpectedPrice(String customerId) async {
    final raw = _prefs.getData(key: 'campaign_checkout_pending_$customerId');
    if (raw is! String) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return (data['expectedFinalPrice'] as num?)?.toDouble();
  }

  Future<Map<String, dynamic>?> readSession(String customerId) async {
    final raw = _prefs.getData(key: 'campaign_session_$customerId');
    if (raw is! String) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clearPending(String customerId) async {
    if (!await _prefs.removeData(
      key: 'campaign_checkout_pending_$customerId',
    )) {
      throw StateError('Could not clear campaign checkout');
    }
    await _prefs.removeData(key: 'campaign_session_$customerId');
  }

  Future<void> _savePending(
    CreateCampaignCheckoutSessionRequestDto request, {
    double? expectedFinalPrice,
  }) async {
    if (!await _prefs.saveData(
      key: 'campaign_checkout_pending_${request.customerId}',
      val: jsonEncode({
        ...request.toJson(),
        'expectedFinalPrice': expectedFinalPrice,
      }),
    )) {
      throw StateError('Campaign checkout could not be persisted');
    }
  }

  Future<CreateCampaignCheckoutSessionRequestDto> restoreOrSave(
    CreateCampaignCheckoutSessionRequestDto request, {
    double? expectedFinalPrice,
  }) async {
    final pending = await readPending(request.customerId);
    if (pending != null && pending.quoteId != request.quoteId) {
      throw StateError(
        'Resolve the previous campaign checkout before starting another',
      );
    }
    final key = 'campaign_checkout_${request.customerId}_${request.quoteId}';
    final raw = _prefs.getData(key: key);
    if (raw is String) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (data['campaignId'] != request.campaignId ||
          data['bundleId'] != request.bundleId ||
          data['durationDays'] != request.durationDays ||
          data['customerId'] != request.customerId ||
          data['quoteId'] != request.quoteId) {
        throw StateError(
          'Campaign checkout selection conflicts with persisted attempt',
        );
      }
      final restored = CreateCampaignCheckoutSessionRequestDto(
        campaignId: data['campaignId'] as String,
        bundleId: data['bundleId'] as String,
        customerId: data['customerId'] as String,
        durationDays: data['durationDays'] as int,
        quoteId: data['quoteId'] as String,
        idempotencyKey: data['idempotencyKey'] as String,
      );
      await _savePending(
        restored,
        expectedFinalPrice: (data['expectedFinalPrice'] as num?)?.toDouble(),
      );
      return restored;
    }
    final random = Random.secure();
    final stable = CreateCampaignCheckoutSessionRequestDto(
      campaignId: request.campaignId,
      bundleId: request.bundleId,
      customerId: request.customerId,
      durationDays: request.durationDays,
      quoteId: request.quoteId,
      idempotencyKey:
          request.idempotencyKey ??
          'cc-${List.generate(24, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join()}',
    );
    if (!await _prefs.saveData(
      key: key,
      val: jsonEncode({
        ...stable.toJson(),
        'expectedFinalPrice': expectedFinalPrice,
      }),
    )) {
      throw StateError('Campaign checkout could not be persisted');
    }
    await _savePending(stable, expectedFinalPrice: expectedFinalPrice);
    return stable;
  }

  Future<void> saveSession(
    String customerId,
    Map<String, dynamic> response,
  ) async {
    if (!await _prefs.saveData(
      key: 'campaign_session_$customerId',
      val: jsonEncode(response),
    )) {
      throw StateError('Campaign session could not be persisted');
    }
  }
}
