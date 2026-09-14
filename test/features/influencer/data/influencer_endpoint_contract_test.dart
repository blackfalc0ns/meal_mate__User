import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ApiServices exposes every influencer backend operation', () {
    final source = File(
      'lib/core/network/api_services.dart',
    ).readAsStringSync();
    for (final method in const [
      'getInfluencerBanks',
      'getInfluencerProfile',
      'updateInfluencerSocialLinks',
      'getInfluencerHome',
      'getInfluencerLinks',
      'getInfluencerActivities',
      'getInfluencerWallet',
      'getInfluencerBankAccount',
      'saveInfluencerBankAccount',
      'deleteInfluencerBankAccount',
      'createInfluencerWithdrawal',
      'getInfluencerWithdrawals',
      'getInfluencerWithdrawal',
      'cancelInfluencerWithdrawal',
      'getInfluencerAnalytics',
    ]) {
      expect(source, contains(method));
    }
  });
}
