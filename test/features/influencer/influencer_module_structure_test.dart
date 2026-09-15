import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every influencer module owns its backend layers', () {
    for (final module in const [
      'dashboard',
      'social_links',
      'bank_account',
      'wallet',
      'analytics',
    ]) {
      final root = Directory('lib/features/influencer/$module');
      expect(
        Directory('${root.path}/data').existsSync(),
        isTrue,
        reason: module,
      );
      expect(
        Directory('${root.path}/domain').existsSync(),
        isTrue,
        reason: module,
      );
      expect(
        Directory('${root.path}/presentation').existsSync(),
        isTrue,
        reason: module,
      );
    }
  });

  test('dashboard repository does not own other module operations', () {
    final source = File(
      'lib/features/influencer/dashboard/domain/repo/influencer_dashboard_repository.dart',
    ).readAsStringSync();
    expect(source, isNot(contains('createWithdrawal')));
    expect(source, isNot(contains('saveBankAccount')));
    expect(source, isNot(contains('getAnalytics')));
    expect(source, isNot(contains('updateSocialLinks')));
  });

  test(
    'module data and domain layers never import another influencer module',
    () {
      for (final module in const [
        'dashboard',
        'social_links',
        'bank_account',
        'wallet',
        'analytics',
      ]) {
        for (final layer in const ['data', 'domain']) {
          final files = Directory('lib/features/influencer/$module/$layer')
              .listSync(recursive: true)
              .whereType<File>()
              .where((file) => file.path.endsWith('.dart'));
          for (final file in files) {
            final source = file.readAsStringSync();
            for (final other in const [
              'dashboard',
              'social_links',
              'bank_account',
              'wallet',
              'analytics',
            ]) {
              if (other == module) continue;
              expect(
                source,
                isNot(contains('features/influencer/$other/')),
                reason: file.path,
              );
              expect(
                source,
                isNot(contains('../../../$other/')),
                reason: file.path,
              );
            }
          }
        }
      }
    },
  );

  test('all influencer DTO model files use json_serializable', () {
    final modelFiles = Directory('lib/features/influencer')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.contains(
                '${Platform.pathSeparator}data${Platform.pathSeparator}models${Platform.pathSeparator}',
              ) &&
              file.path.endsWith('.dart') &&
              !file.path.endsWith('.g.dart'),
        );

    expect(modelFiles, isNotEmpty);
    for (final file in modelFiles) {
      final source = file.readAsStringSync();
      expect(
        source,
        contains("import 'package:json_annotation/json_annotation.dart';"),
        reason: file.path,
      );
      expect(source, contains('@JsonSerializable'), reason: file.path);
      expect(source, contains("part '"), reason: file.path);
    }
  });

  test('production influencer code has no fake data source', () {
    final files = Directory('lib/features/influencer')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(contains('InfluencerFakeDataSource')),
        reason: file.path,
      );
      expect(
        source,
        isNot(contains('influencer_fake_data_source')),
        reason: file.path,
      );
    }
  });

  test('influencer ViewModels follow the event and use-case boundary', () {
    final viewModels = Directory('lib/features/influencer')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('_view_model.dart'));

    expect(viewModels, isNotEmpty);
    for (final file in viewModels) {
      final source = file.readAsStringSync();
      expect(source, contains('doIntent('), reason: file.path);
      expect(source, contains('/usecase/'), reason: file.path);
      expect(source, isNot(contains('/data_source/')), reason: file.path);
      expect(source, isNot(contains('/repo/')), reason: file.path);
      expect(source, isNot(contains('Dto')), reason: file.path);
    }
  });
}
