import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/external_modules.dart';

void main() {
  test('network logger does not write through Flutter stdout', () {
    final printedMessages = <String>[];
    final logger = TestExternalModules().providePrettyDioLogger();

    runZoned(
      () => logger.logPrint('network response body'),
      zoneSpecification: ZoneSpecification(
        print: (_, _, _, message) => printedMessages.add(message),
      ),
    );

    expect(printedMessages, isEmpty);
  });
}

class TestExternalModules extends ExternalModules {}
