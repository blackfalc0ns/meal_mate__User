import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
