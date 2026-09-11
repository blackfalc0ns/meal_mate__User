import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('family catalog endpoints use the family subscription flow', () {
    final endpoints = File(
      'lib/core/network/network_constants.dart',
    ).readAsStringSync();

    expect(
      endpoints,
      contains(
        '/api/v1/customer/family-subscription-flow/programs/{programId}/durations',
      ),
    );
    expect(
      endpoints,
      contains(
        '/api/v1/customer/family-subscription-flow/programs/{programId}/tiers',
      ),
    );
  });

  test(
    'family tier request sends the selected member and optional pricing inputs',
    () {
      final api = File('lib/core/network/api_services.dart').readAsStringSync();

      expect(api, contains('getFamilySubscriptionTiers'));
      expect(api, contains("@Query('bundleId') String? bundleId"));
      expect(api, contains("@Query('durationDays') int? durationDays"));
      expect(api, contains("@Query('familyMemberId') String familyMemberId"));
    },
  );

  test('tier endpoints declare the family member query', () {
    final api = File('lib/core/network/api_services.dart').readAsStringSync();

    expect(
      RegExp(
        r"@Query\('familyMemberId'\) String\? familyMemberId",
      ).allMatches(api),
      hasLength(2),
    );
  });

  test('family package requests tiers for the selected member', () {
    final viewModel = File(
      'lib/features/family_package_days/presentation/manager/family_package_days_view_model.dart',
    ).readAsStringSync();

    expect(
      RegExp(r'familyMemberId: member\.memberId').allMatches(viewModel),
      hasLength(greaterThanOrEqualTo(2)),
    );
  });

  test('plan selections stay local until the user continues', () {
    final viewModel = File(
      'lib/features/family_package_days/presentation/manager/family_package_days_view_model.dart',
    ).readAsStringSync();

    expect(viewModel, isNot(contains('_getDurations(')));
    expect(viewModel, isNot(contains('_reloadTiersForMember(')));
  });
}
