import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const forbiddenFragments = <String>[
    'features/calendar/presentation/calendar_home/',
    'features/calendar/presentation/meal_selection/',
    'features/calendar/presentation/restaurant_picker/',
    'features/calendar/presentation/shared_calendar_widgets/',
  ];

  const duplicateDirectories = <String>[
    'lib/features/calendar/presentation/calendar_home',
    'lib/features/calendar/presentation/meal_selection',
    'lib/features/calendar/presentation/restaurant_picker',
    'lib/features/calendar/presentation/shared_calendar_widgets',
  ];

  test('duplicate calendar presentation directories do not exist', () {
    for (final dirPath in duplicateDirectories) {
      expect(
        Directory(dirPath).existsSync(),
        isFalse,
        reason: 'Duplicate directory $dirPath should have been removed',
      );
    }
  });

  test(
    'no dart file imports forbidden duplicate calendar presentation paths',
    () {
      final libDir = Directory('lib');
      expect(libDir.existsSync(), isTrue);

      final violations = <String>[];

      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final content = entity.readAsStringSync();
          for (final fragment in forbiddenFragments) {
            if (content.contains(fragment)) {
              violations.add(
                '${entity.path} contains forbidden import fragment: $fragment',
              );
            }
          }
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    },
  );

  test('routing_generator.dart imports canonical calendar_screen.dart', () {
    final routingFile = File('lib/config/routing/routing_generator.dart');
    expect(routingFile.existsSync(), isTrue);

    final content = routingFile.readAsStringSync();
    expect(
      content.contains(
        'features/calendar/presentation/screens/calendar_screen.dart',
      ),
      isTrue,
      reason:
          'routing_generator.dart must import the canonical calendar_screen.dart',
    );
  });
}
