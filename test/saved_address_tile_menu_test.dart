import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/saved_address_tile.dart';

void main() {
  testWidgets('saved address delete action requires confirmation', (
    tester,
  ) async {
    var defaultCount = 0;
    var deleteCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SavedAddressTile(
            icon: Icons.home_rounded,
            title: 'Home',
            address: 'Capital, Rawda, Block 1',
            onSetDefault: () {
              defaultCount++;
            },
            onDelete: () {
              deleteCount++;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.more_horiz_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Set as default'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Set as default'));
    await tester.pumpAndSettle();
    expect(defaultCount, 1);

    await tester.tap(find.byIcon(Icons.more_horiz_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deleteCount, 0);
    expect(find.text('Delete address?'), findsOneWidget);

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(deleteCount, 1);
  });
}
