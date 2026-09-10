import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';

void main() {
  const expectedEnglishMessages = <String, String>{
    'family.cannot_remove_manager': 'The family manager cannot be removed.',
    'family.member_not_found': 'This family member could not be found.',
    'family.not_manager': 'Only the family manager can perform this action.',
    'family.use_checkout_flow':
        'Add family members through the subscription checkout flow.',
    'family.manager_permissions_immutable':
        "The family manager's permissions cannot be changed.",
    'family.member_paused': 'This family member is paused.',
    'family.permission_denied':
        'This family member does not have permission to edit meals.',
    'subscription.renewal_not_available':
        'This subscription cannot be renewed right now.',
    'common.not_found': 'The requested family subscription was not found.',
    'errors.common.not_found': 'Not found',
    'auth.forbidden': 'This action is only available to customers.',
  };

  testWidgets('maps family backend codes to localized user messages', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    for (final entry in expectedEnglishMessages.entries) {
      expect(mapFailureMessage(context, entry.key), entry.value);
    }
  });
}
