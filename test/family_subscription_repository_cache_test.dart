import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/data_source/family_subscription_setup_remote_data_source.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/repo/family_subscription_setup_repository_impl.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

void main() {
  test(
    'current flow shares an in-flight request and then reuses its snapshot',
    () async {
      final remote = _CountingFamilyRemoteDataSource();
      final repository = FamilySubscriptionSetupRepositoryImpl(
        remote,
        FamilyFlowSnapshotStore(),
      );

      final first = repository.getFamilySubscriptionCurrent();
      final second = repository.getFamilySubscriptionCurrent();
      expect(remote.currentRequests, 1);

      remote.completeCurrent(
        const FamilyFlowCurrentResponseDto(name: 'Family'),
      );
      await Future.wait([first, second]);
      await repository.getFamilySubscriptionCurrent();

      expect(remote.currentRequests, 1);
    },
  );

  test('an invalidation prevents an older response restoring stale data', () {
    final store = FamilyFlowSnapshotStore();
    final revision = store.revision;
    store.invalidate();

    final updated = store.updateIfUnchanged(
      revision,
      const FamilyFlowCurrentEntity(name: 'stale'),
    );

    expect(updated, isFalse);
    expect(store.current, isNull);
  });
}

class _CountingFamilyRemoteDataSource
    implements FamilySubscriptionSetupRemoteDataSource {
  int currentRequests = 0;
  Completer<FamilyFlowCurrentResponseDto>? _currentCompleter;

  @override
  Future<FamilyFlowCurrentResponseDto> getFamilySubscriptionCurrent() {
    currentRequests++;
    return (_currentCompleter ??= Completer<FamilyFlowCurrentResponseDto>())
        .future;
  }

  void completeCurrent(FamilyFlowCurrentResponseDto response) {
    _currentCompleter!.complete(response);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
