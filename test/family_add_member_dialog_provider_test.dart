import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('family member bottom sheet keeps the setup view model provider', () {
    final source = File(
      'lib/features/family_subscription_setup/presentation/widgets/'
      'family_add_member_dialog.dart',
    ).readAsStringSync();

    expect(
      source,
      contains('BlocProvider<FamilySubscriptionSetupViewModel>.value('),
    );
    expect(source, contains('value: viewModel'));
  });
}
