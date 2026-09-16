import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

void main() {
  testWidgets('iconBeforeText places the icon before Arabic button text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                AppButton.filled(
                  key: Key('before'),
                  text: 'التالي',
                  iconWidget: Icon(Icons.arrow_forward),
                  iconBeforeText: true,
                  isExpanded: false,
                ),
                AppButton.filled(
                  key: Key('default'),
                  text: 'التالي',
                  iconWidget: Icon(Icons.arrow_forward),
                  isExpanded: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final beforeButton = find.byKey(const Key('before'));
    final defaultButton = find.byKey(const Key('default'));
    final beforeIcon = find.descendant(
      of: beforeButton,
      matching: find.byIcon(Icons.arrow_forward),
    );
    final beforeText = find.descendant(
      of: beforeButton,
      matching: find.text('التالي'),
    );
    final defaultIcon = find.descendant(
      of: defaultButton,
      matching: find.byIcon(Icons.arrow_forward),
    );
    final defaultText = find.descendant(
      of: defaultButton,
      matching: find.text('التالي'),
    );

    expect(
      tester.getCenter(beforeIcon).dx,
      greaterThan(tester.getCenter(beforeText).dx),
    );
    expect(
      tester.getCenter(defaultIcon).dx,
      lessThan(tester.getCenter(defaultText).dx),
    );
  });
}
