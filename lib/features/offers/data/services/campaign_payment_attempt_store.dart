import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';

@injectable
class CampaignPaymentAttemptStore {
  const CampaignPaymentAttemptStore(this._prefs, this._token);
  final SharedPrefHelper _prefs;
  final TokenService _token;

  Future<StartCampaignPaymentRequestEntity> restoreOrSave(
    StartCampaignPaymentRequestEntity request,
  ) async {
    final owner = await _token.getCurrentUserId();
    if (owner == null || owner.isEmpty) {
      throw StateError('Authenticated customer is required');
    }
    final key = 'campaign_payment_${owner}_${request.sessionId}';
    final raw = _prefs.getData(key: key);
    if (raw is String) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (data['sessionId'] != request.sessionId || data['owner'] != owner) {
        throw StateError('Payment attempt owner mismatch');
      }
      return StartCampaignPaymentRequestEntity(
        sessionId: request.sessionId,
        idempotencyKey: data['idempotencyKey'] as String,
        paymentMethodId: data['paymentMethodId'] as int,
        callbackUrl: data['callbackUrl'] as String,
        errorUrl: data['errorUrl'] as String,
      );
    }
    final saved = await _prefs.saveData(
      key: key,
      val: jsonEncode({
        'owner': owner,
        'sessionId': request.sessionId,
        'idempotencyKey': request.idempotencyKey,
        'paymentMethodId': request.paymentMethodId,
        'callbackUrl': request.callbackUrl,
        'errorUrl': request.errorUrl,
      }),
    );
    if (!saved) throw StateError('Payment attempt could not be persisted');
    return request;
  }
}
