import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const forbiddenFragments = <String>[
    'features/calendar/presentation/calendar_home/',
    'features/calendar/presentation/meal_selection/',
    'features/calendar/presentation/restaurant_picker/',
    'features/calendar/presentation/shared_calendar_widgets/',
    'features/calendar/presentation/manager/calendar_view_model.dart',
    'features/calendar/presentation/manager/calendar_state.dart',
    'features/calendar/presentation/manager/calendar_event.dart',
  ];

  const duplicateDirectories = <String>[
    'lib/features/calendar/presentation/calendar_home',
    'lib/features/calendar/presentation/meal_selection',
    'lib/features/calendar/presentation/restaurant_picker',
    'lib/features/calendar/presentation/shared_calendar_widgets',
  ];

  const legacyManagerFiles = <String>[
    'lib/features/calendar/presentation/manager/calendar_view_model.dart',
    'lib/features/calendar/presentation/manager/calendar_view_model_days.dart',
    'lib/features/calendar/presentation/manager/calendar_view_model_restaurants.dart',
    'lib/features/calendar/presentation/manager/calendar_view_model_meals.dart',
    'lib/features/calendar/presentation/manager/calendar_view_model_actions.dart',
    'lib/features/calendar/presentation/manager/calendar_state.dart',
    'lib/features/calendar/presentation/manager/calendar_state_extensions.dart',
    'lib/features/calendar/presentation/manager/calendar_event.dart',
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

  test('legacy combined manager files do not exist', () {
    for (final filePath in legacyManagerFiles) {
      expect(
        File(filePath).existsSync(),
        isFalse,
        reason: 'Legacy manager file $filePath should have been removed',
      );
    }
  });

  test('each sub-manager contains state, event, and viewmodel', () {
    const expectedSubManagers = <String, List<String>>{
      'overview': [
        'calendar_overview_state.dart',
        'calendar_overview_event.dart',
        'calendar_overview_view_model.dart',
      ],
      'restaurant_picker': [
        'restaurant_picker_state.dart',
        'restaurant_picker_event.dart',
        'restaurant_picker_view_model.dart',
      ],
      'meal_selection': [
        'meal_selection_state.dart',
        'meal_selection_event.dart',
        'meal_selection_view_model.dart',
      ],
      'flow': [
        'calendar_flow_state.dart',
        'calendar_flow_event.dart',
        'calendar_flow_view_model.dart',
      ],
    };

    for (final entry in expectedSubManagers.entries) {
      final subDir = 'lib/features/calendar/presentation/manager/${entry.key}';
      expect(
        Directory(subDir).existsSync(),
        isTrue,
        reason: 'Sub-manager directory $subDir must exist',
      );
      for (final fileName in entry.value) {
        final filePath = '$subDir/$fileName';
        expect(
          File(filePath).existsSync(),
          isTrue,
          reason: '$filePath must exist in $subDir',
        );
      }
    }
  });

  test(
    'no dart file imports forbidden duplicate or legacy calendar presentation paths',
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
