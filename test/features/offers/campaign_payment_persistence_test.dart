import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/data/services/campaign_payment_attempt_store.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';

class _Token extends Fake implements TokenService {
  String? owner = 'customer-a';
  @override
  Future<String?> getCurrentUserId() async => owner;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('restarting restores exact payment body and isolates owners', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = SharedPrefHelper(await SharedPreferences.getInstance());
    final token = _Token();
    final first = CampaignPaymentAttemptStore(prefs, token);
    await first.restoreOrSave(
      const StartCampaignPaymentRequestEntity(
        sessionId: 's',
        idempotencyKey: 'original',
        paymentMethodId: 7,
        callbackUrl: 'https://example.com/ok',
      ),
    );
    final restored = await CampaignPaymentAttemptStore(prefs, token)
        .restoreOrSave(
          const StartCampaignPaymentRequestEntity(
            sessionId: 's',
            idempotencyKey: 'new-after-restart',
          ),
        );
    expect(restored.idempotencyKey, 'original');
    expect(restored.paymentMethodId, 7);
    expect(restored.callbackUrl, 'https://example.com/ok');
    token.owner = 'customer-b';
    final other = await first.restoreOrSave(
      const StartCampaignPaymentRequestEntity(
        sessionId: 's',
        idempotencyKey: 'other',
      ),
    );
    expect(other.idempotencyKey, 'other');
  });
}
